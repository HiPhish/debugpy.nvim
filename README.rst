.. default-role:: code

##############
 Debugpy.nvim
##############

Thin and hackable frontend command to nvim-dap_ and Debugpy_ for debugging
Python code in Neovim.  This plugin provides a new command `:Debugpy` which can
take a number of sub-commands to generate an appropriate debugger configuration
on the fly.


Installation
############

- Set up nvim-dap to your liking
- Install the Debugpy adapter into your Python environment
- Install Debugpy.nvim like any other Neovim plugin

You can run the health check (`:checkhealth debugpy`) to verify that all
dependencies are available.

I recommend running nvim-dap manually first to make sure it works before
invoking the `:Debugpy` command from this plugin.  It provides only a way of
starting the debugger, it does not interfere with other aspects of the
debugger.

A reasonable default adapter configuration named `debugpy` is provided, but you
can override it with your own or extend it.


Usage
#####

The new `:Debugpy` command starts the debugger with an appropriate
configuration generated from its parameters.  The first argument is mandatory
and determines what to debug.  Example:

.. code:: vim

   " Debug a certain Python module by running it directly
   Debugpy module app.main

   " Debug an entire program
   Debugpy program app foo bar

   " Attach to a running debugger process on the localhost listening to port
   " 5678 (you have to spell out the IP, typing 'localhost' does not work)
   Debugpy attach 127.0.0.1 5678

Here `module`, `program` and `attach` are the sub-command which tell the
debugger to debug a given module, and `app.main` is the name of the module.
The arity of a sub-command depends on the particular sub-command; e.g. `module`
takes exactly one argument while `program` takes any number of arguments.

For more information please refer to the documentation_.


License
#######

Licensed under the terms of the MIT (Expat) license.  Please refer to the
LICENSE_ file for more information.

.. _nvim-dap: https://github.com/mfussenegger/nvim-dap
.. _Debugpy: https://github.com/microsoft/debugpy
.. _documentation: doc/debugpy.txt
.. _License: LICENSE.txt
