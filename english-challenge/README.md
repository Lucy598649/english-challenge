# 🏆 WPS 英语挑战赛 H5

基于 WPS 英语挑战赛 Excel 题库构建的完整 H5 竞赛系统。

```
english-challenge/
├── frontend/
│   └── index.html        # 全部前端（单文件，零依赖）
├── backend/
│   ├── server.js         # Express API 服务
│   ├── package.json
│   └── data/
│       └── submissions.json   # 自动生成，存储答题记录
├── data/
│   └── questions.json    # 题库（30题）
└── README.md
```

---

## 🚀 快速部署（推荐方案）

### 前端 → GitHub Pages（免费）

1. 把整个仓库 push 到 GitHub
2. Settings → Pages → Branch: `main` / Folder: `/frontend`
3. 访问 `https://你的用户名.github.io/english-challenge/`

### 后端 → Railway（免费）

1. 打开 [railway.app](https://railway.app)，New Project → Deploy from GitHub Repo
2. 选择本仓库，Root Directory 填 `backend`
3. 部署完成后复制生成的 URL，例如 `https://english-challenge.up.railway.app`
4. **打开 `frontend/index.html` 第 6 行，把 API_BASE 替换成该 URL**

```js
// 修改这一行
const API_BASE = 'https://english-challenge.up.railway.app';
```

5. 重新 push 前端，GitHub Pages 自动更新

---

## 🔧 本地开发

```bash
# 后端
cd backend
npm install
npm run dev          # http://localhost:3001

# 前端：直接用浏览器打开 frontend/index.html
# 或用 Live Server VSCode 插件
```

---

## 📡 API 接口说明

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/questions` | 获取题目（不含答案） |
| POST | `/api/submit` | 提交答案，返回得分和解析 |
| GET | `/api/leaderboard` | 排行榜（每人最高分） |
| GET | `/api/stats` | 总参与人数、平均分、满分人数 |

### POST /api/submit 示例

```json
// 请求
{
  "nickname": "张三",
  "answers": {
    "Q01": "B",
    "Q02": "C",
    ...
  }
}

// 响应
{
  "score": 27,
  "rank": "英语达人",
  "total": 30,
  "detail": [
    { "id": "Q01", "correct": "B", "submitted": "B", "isCorrect": true },
    ...
  ]
}
```

---

## 🎮 功能特性

- ✅ 30 道题目，4 大分类（词汇 / 语法 / 文化 / 阅读）
- ✅ 10 分钟倒计时，自动交卷
- ✅ 题目导航面板，随意跳题
- ✅ 提交后展示答题详情和正确答案
- ✅ 5 段位系统（英语新手 → 英语王者）
- ✅ 实时排行榜（每人取最高分）
- ✅ 无后端时自动 fallback，前端仍可作答（无排行榜）
- ✅ 微信 H5 适配（禁止缩放 / 点击高亮处理）

---

## 🌐 微信分享配置

在 `frontend/index.html` 的 `<head>` 中修改：

```html
<meta property="og:title" content="WPS 英语挑战赛">
<meta property="og:description" content="30道题挑战你的英语实力，冲击排行榜！">
<meta property="og:image" content="https://你的域名/cover.png">
```

---

## ➕ 更新题库

编辑 `data/questions.json`，格式：

```json
{
  "id": "Q31",
  "category": "词汇",
  "question": "Your question here?",
  "options": ["A text", "B text", "C text", "D text"],
  "answer": "B"
}
```

重新 push 后后端自动加载。
