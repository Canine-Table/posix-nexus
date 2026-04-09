(in-package #:cl-user)

(defpackage #:tri.compile-layout
  (:use #:cl #:tri.base)
  (:export #:compile-layout))

(in-package #:tri.compile-layout)

(in-package #:cl-user)

(defpackage #:tri.compile-layout
  (:use #:cl #:tri.base)
  (:export #:compile-layout))

(in-package #:tri.compile-layout)
(defun compile-layout ()
  (with-css-file (out "../nex-layout.css")

    (emit-line out "/* TRIG — Content‑Aware Zen Garden Layout */")

    ;; -------------------------
    ;; ICON + FOOTER BASE STYLES
    ;; -------------------------
    (emit-line out "footer > a {")
    (emit-line out "  display: block;")
    (emit-line out "  height: 3rem;")
    (emit-line out "  width: 3rem;")
    (emit-line out "  background: currentcolor;")
    (emit-line out "  mask-size: 3rem;")
    (emit-line out "  mask-repeat: no-repeat;")
    (emit-line out "  mask-position: center;")
    (emit-line out "  cursor: pointer;")
    (emit-line out "  transition: all 0.5s ease 0.1s;")
    (emit-line out "}")

    (emit-line out "footer > a:focus-visible {")
    (emit-line out "  outline: var(--nx-focus-ring-width) solid var(--nx-focus-ring-color);")
    (emit-line out "  outline-offset: 3px;")
    (emit-line out "}")

    ;; Icon masks
    (emit-line out "a.zen-validate-html { mask-image: var(--nx-html); -webkit-mask-image: var(--nx-html); }")
    (emit-line out "a.zen-validate-css { mask-image: var(--nx-css); -webkit-mask-image: var(--nx-css); }")
    (emit-line out "a.zen-github { mask-image: var(--nx-gh); -webkit-mask-image: var(--nx-gh); }")
    (emit-line out "a.zen-accessibility { mask-image: var(--nx-accessible); -webkit-mask-image: var(--nx-accessible); }")
    (emit-line out "a.zen-license { mask-image: var(--nx-cc); -webkit-mask-image: var(--nx-cc); }")

    ;; Footer container
    (emit-line out "#zen-intro { order: 1; }")
    (emit-line out "#zen-supporting { order: 2; padding-bottom: 4rem; }")

    (emit-line out "#zen-supporting > footer {")
    (emit-line out "  display: flex;")
    (emit-line out "  position: absolute;")
    (emit-line out "  bottom: 0;")
    (emit-line out "  left: 0;")
    (emit-line out "  width: 100%;")
    (emit-line out "  justify-content: space-around;")
    (emit-line out "  align-items: center;")
    (emit-line out "  flex-wrap: wrap;")
		(emit-line out "  max-width: 72rem;")
    (emit-line out "  padding: 3rem 0;")
    (emit-line out "}")

    ;; -------------------------
    ;; MOBILE-FIRST LAYOUT (<992px)
    ;; -------------------------
    (emit-line out "/* MOBILE-FIRST LAYOUT */")
    (emit-line out "body#css-zen-garden {")
    (emit-line out "  justify-content: center;")
    (emit-line out "  min-width: 100vw;")
    (emit-line out "  min-height: 100vh;")
    (emit-line out "  display: flex;")
    (emit-line out "}")

    (emit-line out ".page-wrapper {")
    (emit-line out "  display: flex;")
    (emit-line out "  flex-direction: column;")
    (emit-line out "  gap: 2rem;")
    (emit-line out "  position: relative;")
    (emit-line out "  padding: 1.5rem;")
    (emit-line out "  max-width: 72rem;")
    (emit-line out "  justify-content: end;")
    (emit-line out "  ")
    (emit-line out "}")

    ;; Sidebar first on mobile
    (emit-line out "aside.sidebar {")
    (emit-line out "  order: 0;")
    (emit-line out "  display: flex;")
    (emit-line out "  flex-direction: column;")
    (emit-line out "  gap: 1.5rem;")
    (emit-line out "}")

    ;; -------------------------
    ;; DESKTOP LAYOUT (992px+)
    ;; -------------------------
    (emit-line out "@media (min-width: 992px) {")

    (emit-line out "  .page-wrapper {")
    (emit-line out "    display: grid;")
    (emit-line out "    grid-template-columns: 1fr 320px;")
    (emit-line out "    gap: 2rem;")
    (emit-line out "    padding: 2rem;")
    (emit-line out "    padding-bottom: 8rem;")
    (emit-line out "  display: flex;")
    (emit-line out "  }")

    (emit-line out "  #zen-intro, #zen-summary, #zen-preamble { grid-column: 1 / -1; }")

    (emit-line out "  #zen-supporting {")
    (emit-line out "    display: grid;")
    (emit-line out "    unset order;")
    (emit-line out "    grid-template-columns: 1fr 1fr;")
    (emit-line out "    gap: 2rem;")
    (emit-line out "  }")

    (emit-line out "  #zen-explanation { grid-column: 1; }")
    (emit-line out "  #zen-participation { grid-column: 2; }")
    (emit-line out "  #zen-benefits { grid-column: 1 / -1; }")
    (emit-line out "  #zen-requirements { grid-column: 1 / -1; }")

    (emit-line out "#zen-intro { order: unset; }")
    (emit-line out "#zen-supporting { order: unset; }")
    (emit-line out "  aside.sidebar {")
    (emit-line out "    grid-column: 2;")
    (emit-line out "    order: unset;")
    (emit-line out "    gap: 2rem;")
    (emit-line out "  }")

    (emit-line out "}")))

