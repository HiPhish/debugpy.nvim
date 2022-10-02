.. default-role:: code


###################
 Developer's notes
###################


Module path completion
######################

The module path completion of the `:Debugpy module` subcommand is a naive
re-implementation of the way Python looks  for modules.  I was deliberating
whether to implement completion as a Python remote plugin using the `importlib`
and `pkgutil` or whether to write a re-implementation in Lua.  Eventually I
decided to go with the latter.

Remote plugin considerations
============================

Positives
---------

- Can leverage Python libraries
- Always compliant with whatever version of Python the user is using
- Can find packages outside the working directory as well

Negatives
---------

- Dependency on pynvim
- Users have to run `:UpdateRemotePlugins` on each update
- Has to load modules which executes their side effects

Lua re-implementation considerations
====================================

Positives
---------

- No dependencies
- No extra steps or configuration

Negatives
---------

- Might deviate from the Python standard
- Does not include modules outside the working environment

Conclusion
==========

In the end the fact that Python has to actually load packages (executable code)
in order to find submodules made me go with Lua.  An editor plugin should never
implicitly load executable code from its working directory.  While it is very
unlikely that an attacker would exploit this, I prefer erring on the side of
caution.

Python implementation
=====================

Here is an outline of the Python implementation for posterity if someone in the
future decides to relax the security concerns.

.. code-block:: python

   from importlib import import_module
   from pkgutil import iter_modules
   from typeing import List

   def complete_module(arg: string) -> List[string]:
       module = import_module(arg)
       if hasattr(module, '__path__'):
           path, prefix = getattr(module, '__path__'), ''
           return [m.name for m in iter_modules(path)]
       else:
           return [module.__name__]

The code is incomplete: we need to consider the cases when `arg` contains one
or more periods, or no periods, and we need to filter the final list elements.
