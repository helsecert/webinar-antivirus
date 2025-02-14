# IP adresse eller hostnavn til Graylog-serveren
$graylogserver = "127.0.0.1"

# Porten til GELF TCP-inputten
$port = "12201"

# Hvor lenge tilbake scriptet skal hente logger fra. Om du kjører scriptet hvert minutt, la den være på -70 sekunder for å ha litt overlapp
$starttime = (Get-Date).AddSeconds(-70)

$events = Get-WinEvent -FilterHashtable @{
    LogName="Microsoft-Windows-Windows Defender/Operational"; # Se i Defender-loggene
    Id=@(1006, 1015, 1116, 5001, 5004, 5007, 5008, 5010, 5012, 5013); # Ta med de viktigste eventene
    StartTime=$starttime
} -ErrorAction SilentlyContinue

if ($events) {
    $events | Send-PSGelfTCPFromObject -GelfServer $graylogserver -Port $port
}
