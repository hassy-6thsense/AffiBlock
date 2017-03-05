@echo off

rem 変数宣言＆初期化
set hosts=%windir%\system32\drivers\etc\hosts
set hosts_orig=%hosts%.orig
set domain=
set input=

rem hostファイルバックアップ
call :backupHosts

rem 特定ページへのアクセスを問答無用で遮断
call :blockForce

rem 他に遮断したい対象があれば入れてもらう
:menu
echo 1) その他のページへのアクセスを遮断する
echo 2) 終了する
set /P input="実施したい操作を選んでください: "
echo;

if %input% == 1 (
    call :blockDomain
) else if %input% == 2 (
    exit
)

rem 入力用変数を初期化してループ
set input=
goto menu



rem hostsバックアップ関数
:backupHosts

rem hostsファイルバックアップ (バックアップが無い場合のみ)
if not exist %hosts_orig% (
    copy %hosts% %hosts_orig%
    echo %hosts% を %hosts_orig% にバックアップしました。
)

exit /b 0



rem 特定ページへのアクセスを遮断する関数
:blockForce

rem は○ま起稿
call :blockDomain blog.esuteru.com
call :blockDomain ch.esuteru.com

rem オ○的ゲーム速報@刃
call :blockDomain jin115.com

rem や○おん！
call :blockDomain yaraon-blog.com

exit /b 0



rem hostsファイルへの追記関数
:blockDomain

rem 引数が無ければユーザーが入力する
if not "%1%" == "" (
    set domain=%1%
) else (
    echo アクセスしたくないページのURLを入れてください。
    set /P domain="("http://example.com/index.html" なら "example.com" の部分です): "
)

rem 既にhostsファイルに登録されていたらスキップする
findstr "%domain%" %hosts%> nul
if "%ERRORLEVEL%" == "0" (
    set ERRORLEVEL=
    echo "%domain%" へのアクセスは既に遮断されています。
    echo;
    exit /b 0
)

rem IPv4, IPv6どちらも遮断する
set ERRORLEVEL=
cmd /C "echo 127.0.0.1	%domain%>> %hosts%"
cmd /C "echo ::1			%domain%>> %hosts%"
if "%ERRORLEVEL%" == "0" (
    echo "%domain%" へのアクセスを遮断しました。
    echo "%domain%" にアクセスできるようにするには、 "%hosts%" ファイルを開いて、 "127.0.0.1 %domain%" "::1 %domain%" と書いてある行を消してください。
) else (
    echo エラーが発生しました。
)

echo;

rem 入力用変数を初期化してループ
set input=
exit /b 0
