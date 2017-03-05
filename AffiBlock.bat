@echo off

rem �ϐ��錾��������
set hosts=%windir%\system32\drivers\etc\hosts
set hosts_orig=%hosts%.orig
set domain=
set input=

rem host�t�@�C���o�b�N�A�b�v
call :backupHosts

rem ����y�[�W�ւ̃A�N�Z�X��ⓚ���p�ŎՒf
call :blockForce

rem ���ɎՒf�������Ώۂ�����Γ���Ă��炤
:menu
echo 1) ���̑��̃y�[�W�ւ̃A�N�Z�X���Ւf����
echo 2) �I������
set /P input="���{�����������I��ł�������: "
echo;

if %input% == 1 (
    call :blockDomain
) else if %input% == 2 (
    exit
)

rem ���͗p�ϐ������������ă��[�v
set input=
goto menu



rem hosts�o�b�N�A�b�v�֐�
:backupHosts

rem hosts�t�@�C���o�b�N�A�b�v (�o�b�N�A�b�v�������ꍇ�̂�)
if not exist %hosts_orig% (
    copy %hosts% %hosts_orig%
    echo %hosts% �� %hosts_orig% �Ƀo�b�N�A�b�v���܂����B
)

exit /b 0



rem ����y�[�W�ւ̃A�N�Z�X���Ւf����֐�
:blockForce

rem �́��܋N�e
call :blockDomain blog.esuteru.com
call :blockDomain ch.esuteru.com

rem �I���I�Q�[������@�n
call :blockDomain jin115.com

rem �⁛����I
call :blockDomain yaraon-blog.com

exit /b 0



rem hosts�t�@�C���ւ̒ǋL�֐�
:blockDomain

rem ������������΃��[�U�[�����͂���
if not "%1%" == "" (
    set domain=%1%
) else (
    echo �A�N�Z�X�������Ȃ��y�[�W��URL�����Ă��������B
    set /P domain="("http://example.com/index.html" �Ȃ� "example.com" �̕����ł�): "
)

rem ����hosts�t�@�C���ɓo�^����Ă�����X�L�b�v����
findstr "%domain%" %hosts%> nul
if "%ERRORLEVEL%" == "0" (
    set ERRORLEVEL=
    echo "%domain%" �ւ̃A�N�Z�X�͊��ɎՒf����Ă��܂��B
    echo;
    exit /b 0
)

rem IPv4, IPv6�ǂ�����Ւf����
set ERRORLEVEL=
cmd /C "echo 127.0.0.1	%domain%>> %hosts%"
cmd /C "echo ::1			%domain%>> %hosts%"
if "%ERRORLEVEL%" == "0" (
    echo "%domain%" �ւ̃A�N�Z�X���Ւf���܂����B
    echo "%domain%" �ɃA�N�Z�X�ł���悤�ɂ���ɂ́A "%hosts%" �t�@�C�����J���āA "127.0.0.1 %domain%" "::1 %domain%" �Ə����Ă���s�������Ă��������B
) else (
    echo �G���[���������܂����B
)

echo;

rem ���͗p�ϐ������������ă��[�v
set input=
exit /b 0
