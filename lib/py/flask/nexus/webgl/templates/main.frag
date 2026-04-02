vec3 testColor() {
    return vec3(1.0, 0.0, 0.0);
}

precision mediump float;
out vec4 outColor;

void main() {
    outColor = vec4(testColor(), 1.0);
}

