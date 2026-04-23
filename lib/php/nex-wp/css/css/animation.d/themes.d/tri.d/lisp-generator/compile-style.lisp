(in-package #:cl-user)

(defpackage #:tri.compile-style
  (:use #:cl #:tri.base #:tri.extends)
  (:export #:compile-style))

(in-package #:tri.compile-style)


(define-css-block
  ".trig-block"
  '("padding: 2rem 3rem;"
    "border-radius: 1.25rem;"
    "background: radial-gradient(circle at 30% 20%, var(--nx-zero-core) 0%, var(--nx-zero-core-shade) 100%);"
    "backdrop-filter: blur(12px);"
    "box-shadow: 0 0 40px rgba(0,0,0,0.15), inset 0 0 20px rgba(255,255,255,0.05);"
    "animation: nx-tri-bowdish-curve var(--tri-speed-slow) linear infinite;"))

(defun compile-style ()
  (with-css-file (out "../nex-style.css")

    (emit-line out "/* TRIG — Spacy Component Styling */")

    ;; Real CSS class for trig-block
    (emit-line out ".trig-block {")
    (emit-line out "  padding: 2.5rem 3rem;")
    (emit-line out "  margin-bottom: 3rem;")
    (emit-line out "  border-radius: 1.25rem;")
    (emit-line out "  background: radial-gradient(")
    (emit-line out "      circle at 30% 20%,")
    (emit-line out "      var(--nx-zero-core) 0%,")
    (emit-line out "      var(--nx-zero-core-shade) 100%")
    (emit-line out "  );")
    (emit-line out "  backdrop-filter: blur(12px);")
    (emit-line out "  box-shadow:")
    (emit-line out "      0 0 40px rgba(0,0,0,0.15),")
    (emit-line out "      inset 0 0 20px rgba(255,255,255,0.05);")
    (emit-line out "  animation: nx-tri-bowdish-curve var(--tri-speed-slow) linear infinite;")
    (emit-line out "}")

    ;; Intro block
    (extend-css out ".trig-block" "#zen-intro")
    (emit-line out "#zen-intro {")
    (emit-line out "  padding: 4rem 3rem;")
    (emit-line out "}")

    (emit-line out "#zen-summary header {")
    (emit-line out "  justify-self: center;")
    (emit-line out "}")

    ;; Summary + preamble
    (extend-css out ".trig-block" "#zen-summary")
    (extend-css out ".trig-block" "#zen-preamble")

    (emit-line out "#zen-summary {")
    (emit-line out "  background: linear-gradient(135deg, var(--nx-zero-core), transparent);")
    (emit-line out "  box-shadow: none;")
    (emit-line out "  backdrop-filter: blur(8px);")
    (emit-line out "}")

    (emit-line out "#zen-preamble {")
    (emit-line out "  background: linear-gradient(135deg, var(--nx-zero-core), transparent);")
    (emit-line out "  box-shadow: none;")
    (emit-line out "  backdrop-filter: blur(8px);")
    (emit-line out "}")

    ;; Explanation + Participation
    (extend-css out ".trig-block" "#zen-explanation")
    (extend-css out ".trig-block" "#zen-participation")

    ;; Benefits
    (extend-css out ".trig-block" "#zen-benefits")
    (emit-line out "#zen-benefits {")
    (emit-line out "  padding: 2rem 2.5rem;")
    (emit-line out "  opacity: 0.9;")
    (emit-line out "}")

    ;; Requirements
    (extend-css out ".trig-block" "#zen-requirements")
    (emit-line out "#zen-requirements {")
    (emit-line out "  padding: 3rem 3.5rem;")
    (emit-line out "  background: radial-gradient(circle at 50% 50%, var(--nx-zero-core-shade), var(--nx-zero-core));")
    (emit-line out "  box-shadow: 0 0 60px rgba(0,0,0,0.25);")
    (emit-line out "}")


    ;; Sidebar
    (extend-css out ".trig-block" ".design-selection")
    (extend-css out ".trig-block" ".design-archives")
    (extend-css out ".trig-block" ".zen-resources")

    (emit-line out ".design-selection, .design-archives {")
    (emit-line out "  margin-bottom: 1rem;")
    (emit-line out "}")

    (emit-line out ".design-selection, .design-archives, .zen-resources {")
    (emit-line out "  padding: 1.75rem 2rem;")
    (emit-line out "  background: rgba(255,255,255,0.03);")
    (emit-line out "  box-shadow: inset 0 0 20px rgba(255,255,255,0.04);")
    (emit-line out "}")))


