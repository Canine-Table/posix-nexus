\RequirePackage{ifluatex}%
\ifluatex%
	\usepackage{luacode}%
\else%
	\PackageError{luacode}{LuaTeX is required, but not detected}{}%
\fi%

