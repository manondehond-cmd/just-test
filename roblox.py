from flask import Flask, jsonify
import requests
import threading
import time

app = Flask(__name__)

GAME_ID = "YOUR_GAME_ID"  # <-- Replace this with your game's ID
REFRESH_INTERVAL = 30     # seconds
JOB_LIMIT = 10

cached_job_ids = []

def fetch_job_ids():
    global cached_job_ids
    url = f"https://games.roblox.com/v1/games/{GAME_ID}/servers/Public?sortOrder=Asc&limit=100"

    try:
        response = requests.get(url, timeout=5)
        data = response.json()

        job_ids = []
        for server in data.get("data", []):
            if server.get("playing", 0) > 0:
                job_ids.append(server["id"])
            if len(job_ids) >= JOB_LIMIT:
                break

        cached_job_ids = job_ids
        print(f"[{time.strftime('%X')}] Refreshed job list: {len(job_ids)} servers.")
    except Exception as e:
        print("Error refreshing job IDs:", e)

def refresh_loop():
    while True:
        fetch_job_ids()
        time.sleep(REFRESH_INTERVAL)

@app.route("/jobids")
def jobids():
    return jsonify({"job_ids": cached_job_ids})

if __name__ == "__main__":
    print("Starting server on http://0.0.0.0:5000/jobids")
    threading.Thread(target=refresh_loop, daemon=True).start()
    app.run(host="0.0.0.0", port=5000)
