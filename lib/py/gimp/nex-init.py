#!/usr/bin/python3

import sys
from gi.repository import Gimp, Gio, GLib, GObject
print("Plug-in starting...")

class SetBGBlue(Gimp.PlugIn):
    def do_query_procedures(self):
        return ['python-fu-set-bg-blue']

    def do_create_procedure(self, name):
        print(f"Creating procedure: {name}")
        procedure = Gimp.Procedure.new(
            self,
            name,
            Gimp.PDBProcType.PLUGIN,
            self.run,
            None
        )
        procedure.set_menu_label("Set Background to Blue")
        procedure.set_attribution("Canine-Table", "Posix-Nexus", "2025")
        procedure.set_documentation("Sets the background color to blue", "Sets the background color to blue", name)
        procedure.set_image_types("*")
        procedure.add_menu_path("<Image>/Filters/Custom")
        return procedure

    def run(self, procedure, run_mode, image, n_drawables, drawables, args, data):
        Gimp.context_set_background(Gimp.RGB(0.0, 0.0, 1.0))  # RGB values are floats from 0.0 to 1.0
        print("SetBGBlue plug-in loaded and running!")
        return procedure.new_return_values(Gimp.PDBStatusType.SUCCESS, GLib.Error())

Gimp.main(SetBGBlue.__gtype__, sys.argv)

