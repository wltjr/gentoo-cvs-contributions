#!/bin/bash
ESDL_ROOT="/usr/lib/erlang/lib/esdl"
WINGS_ROOT="/usr/lib/erlang/lib/wings"
exec erl -noshell -pa $ESDL_ROOT/ebin $WINGS_ROOT/ebin -run wings_start start_halt
