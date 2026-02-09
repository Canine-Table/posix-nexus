from typing import Any, Callable, Dict, Optional
from jinja2 import Environment, BaseLoader, select_autoescape
from flask import (
    url_for, get_flashed_messages,
    request, session, g, current_app,
    flash, redirect
)

from jinja2.ext import do, i18n, loopcontrols
import secrets
import sys

class NxJinjaBase(Environment):
    """
    Custom Jinja2 environment for the Nexus framework.
    This class is responsible for:
      - registering filters
      - registering global variables
      - configuring environment behavior
    It does NOT discover templates or walk the filesystem.
    """

    filters: Dict[str, Callable[..., Any]]
    globals: Dict[str, Any]

    def __init__(
        self,
        loader: Optional[BaseLoader] = None,
        autoescape: bool = True,
        trim_blocks: bool = True,
        lstrip_blocks: bool = True,
    ) -> None:

        super().__init__(
            loader=loader,
            autoescape=autoescape,
            trim_blocks=trim_blocks,
            lstrip_blocks=lstrip_blocks,
        )

        # Register built-in Nexus extentions
        self._register_default_extentions()

        # Register built-in Nexus filters
        self._register_default_filters()

        # Register built-in Nexus globals
        self._register_default_globals()

    # ---------------------------------------------------------
    # Filter registration
    # ---------------------------------------------------------

    def _register_default_filters(self) -> None:
        """
        Register framework-level filters.
        Add more as your framework grows.
        """
        self.filters["debug"] = self._filter_debug
        self.filters["indent"] = self._filter_indent

    @staticmethod
    def _filter_debug(value: Any) -> str:
        """Simple debug filter to inspect values in templates."""
        return f"<pre>{repr(value)}</pre>"

    @staticmethod
    def _filter_indent(value: str, spaces: int = 4) -> str:
        """Indent a block of text by N spaces."""
        pad = " " * spaces
        return "\n".join(pad + line for line in value.splitlines())

    # ---------------------------------------------------------
    # Extention registration
    # ---------------------------------------------------------

    def _register_default_extentions(self) -> None:
        """
        Register extentions available in all templates.
        """
        self.add_extension(loopcontrols)
        self.add_extension(i18n)
        self.add_extension(do)

    # ---------------------------------------------------------
    # Global registration
    # ---------------------------------------------------------

    def _register_default_globals(self) -> None:
        """
        Register global variables available in all templates.
        """
        self.globals.update({
            "secrets": secrets,
            "redirect": redirect,
            "python_version": sys.version,
            "python_version_info": sys.version_info,
            "dir": dir,
            "url_for": url_for,
            "get_flashed_messages": get_flashed_messages,
            "flash": flash,
            "request": request,
            "session": session,
            "g": g
        })

