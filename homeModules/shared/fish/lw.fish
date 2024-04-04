function _lw_build
    cargo build
end

function _lw_server
    set command $argv[1]
    switch "$command"
        case t
            _lw_build &&
            sudo -E ip netns exec lightway-server target/debug/lightway-server --config-file=ignore_server_conf.yaml --mode tcp
        case u
            _lw_build &&
            sudo -E ip netns exec lightway-server target/debug/lightway-server --config-file=ignore_server_conf.yaml --mode udp
        case b
            sudo -E ip netns exec lightway-server bash
        case \*
            printf "error: Unknown server option %s\n" $command
    end
end

function _lw_client
    set command $argv[1]
    switch "$command"
        case t
            _lw_build &&
            sudo -E ip netns exec lightway-client target/debug/lightway-client --config-file=ignore_client_conf.yaml --mode tcp
        case u
            _lw_build &&
            sudo -E ip netns exec lightway-client target/debug/lightway-client --config-file=ignore_client_conf.yaml --mode udp
        case it
            sudo -E ip netns exec lightway-client iperf3 -c 8.8.8.8 -V -b 2G -l 1200
        case iu
            sudo -E ip netns exec lightway-client iperf3 -c 8.8.8.8 -V -b 2G -l 1200 -u
        case p
            sudo -E ip netns exec lightway-client ping 8.8.8.8 -s 100 -c 2
        case b
            sudo -E ip netns exec lightway-client bash
        case \*
            printf "error: Unknown client option %s\n" $command
    end
end

function _lw_remote
    set command $argv[1]
    switch "$command"
        case s
            sudo -E ip netns exec lightway-remote iperf3 -s -B 8.8.8.8 -i 0
        case b
            sudo -E ip netns exec lightway-remote bash
        case \*
            printf "error: Unknown client option %s\n" $command
    end
end

function lw
    set command $argv[1]
    switch "$command"
        case l
            cargo fmt &&
            cargo clippy --fix --allow-dirty --allow-staged --all-features --all-targets -- -D warnings &&
            cargo nextest run
        case c
            _lw_client $argv[2..-1]
        case s
            _lw_server $argv[2..-1]
        case r
            _lw_remote $argv[2..-1]
        case \*
            printf "error: Unknown option %s\n" $command
    end
end
