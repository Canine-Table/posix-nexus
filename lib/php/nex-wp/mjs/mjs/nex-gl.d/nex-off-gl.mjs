// nex-off-gl.mjs
// This file will be flattened by NxInclude and turned into a Blob worker script.

// #nx_include other-files-if-you-want.mjs
// (NxInclude will inline them)

class NxGlWorker {
    constructor() {
        this.canvas = null;
        this.gl = null;
    }

    init(canvas) {
        this.canvas = canvas;
        this.gl = canvas.getContext("webgl2");

        if (!this.gl) {
            postMessage({ type: "error", message: "WebGL2 not supported" });
            return;
        }

        this.drawOnce();
    }

    drawOnce() {
        const gl = this.gl;

        gl.viewport(0, 0, this.canvas.width, this.canvas.height);
        gl.clearColor(1.0, 0.0, 0.0, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT);

        const bmp = this.canvas.transferToImageBitmap();
        postMessage({ type: "frame", bitmap: bmp }, [bmp]);
    }
}

// Instantiate the worker backend
const worker = new NxGlWorker();

// Message router
onmessage = (ev) => {
    if (ev.data.type === "init") {
        worker.init(ev.data.canvas);
    }
};

