from ultralytics import YOLO

model = YOLO("runs/yolov8n.pt")
results = model("output.mp4", save=True, project="runs", name="out")[0]


for box in results.boxes:
    cls = int(box.cls)
    conf = float(box.conf)
    x1, y1, x2, y2 = box.xyxy[0]
    print(cls, conf, x1, y1, x2, y2)

