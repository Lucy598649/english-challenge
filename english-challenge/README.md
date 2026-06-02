# 🏆 英语挑战赛 H5

30 道英语选择题，覆盖词汇、语法、文化与阅读。前端托管 GitHub Pages，后端本地运行。

```
english-challenge/
├── frontend/
│   └── index.html          # 单文件前端（零依赖）
├── backend/
│   ├── server.js           # Express API
│   ├── package.json
│   └── data/
│       └── submissions.json  # 自动生成，本地存储答题记录
├── data/
│   └── questions.json      # 题库（30题，含答案）
└── start.sh                # 一键启动后端
```

---

## 🚀 使用方式

### 1. 启动后端

```bash
./start.sh
```

首次运行自动安装依赖。输出：

```
🏆  English Challenge Backend
  API:  http://localhost:3001
  Data: backend/data/submissions.json
```

关闭终端窗口即停止服务。

### 2. 打开前端

浏览器访问：**https://lucy598649.github.io/english-challenge/**

或者直接打开 `english-challenge/frontend/index.html`（离线也能答题）。

前端自动连接本地后端。后端没启动时会降级到离线模式——题库内置了正确答案和中文解析，照样能评分。

---

## 📡 API 接口

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/questions` | 获取题目（不含答案） |
| POST | `/api/submit` | 提交答案，返回得分和逐题解析 |
| GET | `/api/leaderboard` | 排行榜（每人取最高分） |
| GET | `/api/stats` | 参与人数、平均分、满分人数 |

### POST /api/submit

```json
// 请求
{
  "nickname": "张三",
  "answers": { "Q01": "B", "Q02": "C" }
}

// 响应
{
  "score": 27,
  "rank": "英语达人",
  "total": 30,
  "detail": [
    { "id": "Q01", "correct": "B", "submitted": "B", "isCorrect": true }
  ]
}
```

---

## 🎮 功能

- 30 题，4 大分类（词汇 / 语法 / 文化 / 阅读）
- 10 分钟倒计时，自动交卷
- 题目导航面板，随意跳题
- 答完显示正确答案 + 中文解析
- 5 段位系统（英语新手 → 英语王者）
- 本地排行榜（数据存本地）
- 无后端时离线模式仍可答题评分
- H5 移动端适配

---

## ➕ 更新题库

编辑 `data/questions.json`，格式：

```json
{
  "id": "Q31",
  "category": "词汇",
  "question": "Your question?",
  "options": ["A", "B", "C", "D"],
  "answer": "B"
}
```

重启后端生效。
