# docker-erlang-bug
PoC to demonstrate a strange interaction between Docker and Erlang

# Buggy behaviour

>$ docker run edevil/docker-erlang-bug erl -noshell -s test run -s init stop
>FAILED

# Correct behaviour

>$ docker run -ti edevil/docker-erlang-bug /bin/bash
>root@0126724ecedf:/test# erl -noshell -s test run -s init stop
>SUCCESS

# Related

In this PoC, we never receive the "exit_status" message when the external
command finishes. The port seems to remain open. Still don't know if this is
a Docker problem or an Erlang problem.

These issues seem related:

http://erlang.org/pipermail/erlang-questions/2013-September/075385.html
https://github.com/elixir-lang/elixir/issues/3342
https://github.com/docker/docker/issues/8910
https://github.com/rebar/rebar/issues/381
