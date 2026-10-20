"""智能巡检机器人二维仿真系统 —— 后端服务（教学最小版）。

机器人状态保存在内存里：坐标、朝向、步数。
前端通过 /api/state 读取状态，通过 /api/move 下发移动指令。
"""

from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

BASE_DIR = Path(__file__).parent

# 地图配置：12x12 的网格，WALLS 是不能走的格子
GRID_W, GRID_H = 12, 12
WALLS = [(3, 2), (3, 3), (6, 5), (7, 5), (8, 5), (2, 8), (3, 8)]

app = FastAPI(title="智能巡检机器人二维仿真系统")

# 全局状态：单人项目用内存字典足够，重启服务即复位
state = {"x": 1, "y": 1, "facing": "down", "steps": 0}

FACING = {(0, -1): "up", (0, 1): "down", (-1, 0): "left", (1, 0): "right"}


class MoveCommand(BaseModel):
    """前端下发的一条移动指令，dx/dy 取 -1、0、1。"""

    dx: int = 0
    dy: int = 0


def snapshot() -> dict:
    """把当前状态打包成前端需要的 JSON。"""
    return {
        "x": state["x"],
        "y": state["y"],
        "facing": state["facing"],
        "steps": state["steps"],
        "grid": {"w": GRID_W, "h": GRID_H},
        "walls": WALLS,
    }


@app.get("/api/state")
def get_state() -> dict:
    """读取机器人当前状态。"""
    return snapshot()


@app.post("/api/move")
def move(cmd: MoveCommand) -> dict:
    """执行一次移动；撞墙或出界时原地不动，并返回 blocked 标记。"""
    if (cmd.dx, cmd.dy) not in FACING:
        return {**snapshot(), "blocked": True, "reason": "非法方向"}

    nx, ny = state["x"] + cmd.dx, state["y"] + cmd.dy
    if not (0 <= nx < GRID_W and 0 <= ny < GRID_H):
        return {**snapshot(), "blocked": True, "reason": "超出地图"}
    if (nx, ny) in WALLS:
        return {**snapshot(), "blocked": True, "reason": "前方是墙"}

    state["x"], state["y"] = nx, ny
    state["facing"] = FACING[(cmd.dx, cmd.dy)]
    state["steps"] += 1
    return {**snapshot(), "blocked": False}


@app.get("/")
def index() -> FileResponse:
    """返回前端页面。"""
    return FileResponse(BASE_DIR / "static" / "index.html")


app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")
