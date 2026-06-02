import express from 'express';
import cors from 'cors';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3001;
const DB_FILE = path.join(__dirname, 'data', 'submissions.json');

app.use(cors());
app.use(express.json());

// Serve frontend static files
app.use(express.static(path.join(__dirname, '../frontend')));

// ── helpers ──────────────────────────────────────────────
function readDB() {
  if (!fs.existsSync(DB_FILE)) return [];
  return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
}
function writeDB(data) {
  fs.mkdirSync(path.dirname(DB_FILE), { recursive: true });
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}
function calcScore(answers, questions) {
  return questions.reduce((s, q) => s + (answers[q.id] === q.answer ? 1 : 0), 0);
}
function getRank(score) {
  if (score === 30) return '英语王者';
  if (score >= 25) return '英语达人';
  if (score >= 20) return '英语高手';
  if (score >= 15) return '英语学徒';
  return '英语新手';
}

const QUESTIONS = JSON.parse(
  fs.readFileSync(path.join(__dirname, '../data/questions.json'), 'utf8')
);

// ── routes ────────────────────────────────────────────────

// GET /api/questions  — return questions without answers
app.get('/api/questions', (_req, res) => {
  const safe = QUESTIONS.map(({ answer: _a, ...q }) => q);
  res.json(safe);
});

// POST /api/submit  — score and save a submission
app.post('/api/submit', (req, res) => {
  const { nickname, answers } = req.body;
  if (!nickname || !answers) return res.status(400).json({ error: 'Missing fields' });

  const score = calcScore(answers, QUESTIONS);
  const rank  = getRank(score);
  const detail = QUESTIONS.map(q => ({
    id: q.id,
    correct: q.answer,
    submitted: answers[q.id] || null,
    isCorrect: answers[q.id] === q.answer,
  }));

  const record = {
    id: Date.now().toString(),
    nickname,
    score,
    rank,
    submittedAt: new Date().toISOString(),
    answers,
    detail,
  };

  const db = readDB();
  db.push(record);
  writeDB(db);

  res.json({ score, rank, total: QUESTIONS.length, detail });
});

// GET /api/leaderboard  — top 20 by best score per nickname
app.get('/api/leaderboard', (_req, res) => {
  const db = readDB();
  const best = {};
  db.forEach(r => {
    if (!best[r.nickname] || r.score > best[r.nickname].score) best[r.nickname] = r;
  });
  const board = Object.values(best)
    .sort((a, b) => b.score - a.score || new Date(a.submittedAt) - new Date(b.submittedAt))
    .slice(0, 20)
    .map((r, i) => ({ rank: i + 1, nickname: r.nickname, score: r.score, rankTitle: r.rank, submittedAt: r.submittedAt }));
  res.json(board);
});

// GET /api/stats  — aggregate stats
app.get('/api/stats', (_req, res) => {
  const db = readDB();
  if (!db.length) return res.json({ total: 0, avgScore: 0, perfectCount: 0 });
  const total = db.length;
  const avgScore = +(db.reduce((s, r) => s + r.score, 0) / total).toFixed(1);
  const perfectCount = db.filter(r => r.score === 30).length;
  res.json({ total, avgScore, perfectCount });
});

app.listen(PORT, () => console.log(`API running on http://localhost:${PORT}`));
