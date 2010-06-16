#lang scheme

(require
 (combine-in "loader.scm"
             "bresenham.scm"
             "bsp.scm"
             "color.scm"
             "console.scm"
             "fov.scm"
             "heightmap.scm"
             "image.scm"
             "list.scm"
             "mersenne.scm"
             "noise.scm"
             "sys.scm"
             "tree.scm"
             "wrappers.scm"
             "zip.scm"))

(provide
 (prefix-out tcod:
             (all-from-out
              "bresenham.scm"
              "bsp.scm"
              "color.scm"
              "console.scm"
              "fov.scm"
              "heightmap.scm"
              "image.scm"
              "list.scm"
              "mersenne.scm"
              "noise.scm"
              "sys.scm"
              "tree.scm"
              "wrappers.scm"
              "zip.scm")))

