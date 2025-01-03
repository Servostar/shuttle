Describe 'lib/log.sh'
    Include lib/log.sh

    Describe '_log_level_to_string'
        Context
            Parameters
                "#1" 1 "trace"
                "#2" 2 "debug"
                "#3" 3 "info"
                "#4" 4 "warn"
                "#5" 5 "error"
                "#6" 6 "fatal"
            End

            Specify "_log_level_to_string $1"

                When call _log_level_to_string "$2"
                The stdout should equal "$3"
                The status should be success
            End
        End

        Context
            Parameters
                "#1" -1
                "#2" -2
                "#3" 0
                "#4" 9
                "#5" 23
            End

            Specify "_log_level_to_string should fail"
                When call _log_level_to_string "$2"
                The stdout should equal ""
                The status should not be success
            End
        End
    End
End
