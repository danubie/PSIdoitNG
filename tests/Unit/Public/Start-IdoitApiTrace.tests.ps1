BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
}
Describe 'Start-IdoitApiTrace & Stop-IdoitApiTrace' {
    It 'Should start and stop API tracing' {
        # Start tracing
        Start-IdoitApiTrace
        $ret = Get-Variable -Name 'IdoitApiTrace' -Scope Global -ErrorAction SilentlyContinue
        $ret | Should -Not -BeNull
        # Stop tracing
        Stop-IdoitApiTrace
        $ret = Get-Variable -Name 'IdoitApiTrace' -Scope Global -ErrorAction SilentlyContinue
        $ret | Should -BeNull
    }
}