.. default-role:: code


###########
 Changelog
###########

All notable changes to this project will be documented in this file.

The format is based on `Keep a Changelog`_ and this project adheres to
`Semantic Versioning`_.


Unreleased
##########

Changed
   - User manual topics restructured to be more discoverable

Added
   - Arity of custom sub-commands is optional and defaults to `{min=0,
     max=nil}`

0.6.0 - 2022-08-07
##################

Added
   - Default adapter for the name `python`


0.5.0 - 2022-02-02
##################

Added
   - Health check


0.4.0 - 2021-12-25
##################

Christmas gift release!

Added
   - Support for completion of subcommands


0.3.0 - 2021-12-19
##################

Added
   - Subcommand `code`

Fixed
   - `debugpy#configure()` does not raise any errors
   - `debugpy#run()` does not raise any errors


0.2.0 - 2021-12-17
##################

Added
   - Functions `debugpy.configure` and `debugpy#configure`
   - Function `debugpy#run`
   - Introduced changelog


0.1.0 - 2021-12-16
##################

Initial release


.. ---------------------------------------------------------------------------
.. _Keep a Changelog: https://keepachangelog.com/en/1.0.0/
.. _Semantic Versioning: https://semver.org/spec/v2.0.0.html
