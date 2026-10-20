// 前端逻辑：读取后端状态 → 画在 canvas 上 → 键盘按下时向后端下发移动指令

const canvas = document.getElementById("map");
const ctx = canvas.getContext("2d");

const posLabel = document.getElementById("pos");
const facingLabel = document.getElementById("facing");
const stepsLabel = document.getElementById("steps");
const message = document.getElementById("message");

const FACING_TEXT = { up: "上", down: "下", left: "左", right: "右" };
const KEY_TO_MOVE = {
  ArrowUp: [0, -1], ArrowDown: [0, 1], ArrowLeft: [-1, 0], ArrowRight: [1, 0],
  w: [0, -1], s: [0, 1], a: [-1, 0], d: [1, 0],
};

let current = null; // 后端返回的最新状态

/** 把网格坐标换算成 canvas 上的像素位置。 */
function cellSize() {
  return canvas.width / current.grid.w;
}

/** 重画整张地图：格子线、墙、机器人。 */
function draw() {
  const size = cellSize();
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // 网格线
  ctx.strokeStyle = "#1d2740";
  ctx.lineWidth = 1;
  for (let i = 0; i <= current.grid.w; i++) {
    ctx.beginPath();
    ctx.moveTo(i * size, 0);
    ctx.lineTo(i * size, canvas.height);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(0, i * size);
    ctx.lineTo(canvas.width, i * size);
    ctx.stroke();
  }

  // 墙
  ctx.fillStyle = "#34405a";
  for (const [x, y] of current.walls) {
    ctx.fillRect(x * size + 1, y * size + 1, size - 2, size - 2);
  }

  // 机器人
  const cx = current.x * size + size / 2;
  const cy = current.y * size + size / 2;
  ctx.fillStyle = "#4da3ff";
  ctx.beginPath();
  ctx.arc(cx, cy, size * 0.3, 0, Math.PI * 2);
  ctx.fill();

  // 朝向指示线
  const dir = { up: [0, -1], down: [0, 1], left: [-1, 0], right: [1, 0] }[current.facing];
  ctx.strokeStyle = "#ffffff";
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.moveTo(cx, cy);
  ctx.lineTo(cx + dir[0] * size * 0.3, cy + dir[1] * size * 0.3);
  ctx.stroke();
}

/** 把后端返回的状态同步到界面。 */
function render(state) {
  current = state;
  posLabel.textContent = `(${state.x}, ${state.y})`;
  facingLabel.textContent = FACING_TEXT[state.facing] || state.facing;
  stepsLabel.textContent = state.steps;
  message.textContent = state.blocked ? `移动失败：${state.reason}` : "";
  draw();
}

async function refresh() {
  const res = await fetch("/api/state");
  render(await res.json());
}

async function sendMove(dx, dy) {
  const res = await fetch("/api/move", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ dx, dy }),
  });
  render(await res.json());
}

document.addEventListener("keydown", (event) => {
  const key = event.key.length === 1 ? event.key.toLowerCase() : event.key;
  const move = KEY_TO_MOVE[key];
  if (!move) return;
  event.preventDefault();
  sendMove(move[0], move[1]);
});

refresh();
