unit AnyDesk.Core;

interface

uses
  Winapi.TlHelp32,
  System.Types;

type
  TAnyDeskRunner = class
  protected
    class function FindProcessID(const ExeName: string): DWORD;
    class function TerminateProcessByPID(PID: DWORD): Boolean;
  public
    class function TerminateProcessByName(const ExeName: string): Boolean;
    class procedure TerminateAllProcessByName(const ExeName: string);
    class procedure RemoveServiceConf;
    class procedure DumpUsersAndThumbnails;
    class function GetAppDataPath: string;
    class procedure RemoveBackup;
    class procedure RunAnyDesk;
    class procedure RestoreUsersAndThumbnails;
  end;

implementation

uses
  ShellApi,
  System.Zip,
  System.IOUtils,
  System.SysUtils,
  Winapi.Windows;

{ TAnyDeskRunner }

class procedure TAnyDeskRunner.DumpUsersAndThumbnails;
var
  LThumbOld, LThumbNew: string;
  LUsersOld, LUsersNew: string;
begin
  LThumbOld := TPath.Combine(GetAppDataPath, 'thumbnails');
  LThumbNew := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'AnyDeskRunner'), 'thumbnails');
  TDirectory.Copy(LThumbOld, LThumbNew);
  LUsersOld := TPath.Combine(GetAppDataPath, 'user.conf');
  LUsersNew := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'AnyDeskRunner'), 'user.conf');
  TFile.Copy(LUsersOld, LUsersNew);
end;

class function TAnyDeskRunner.FindProcessID(const ExeName: string): DWORD;
var
  Snapshot: THandle;
  ProcessEntry: TProcessEntry32;
begin
  Result := 0;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot <> INVALID_HANDLE_VALUE then
    try
      ProcessEntry.dwSize := SizeOf(ProcessEntry);
      if Process32First(Snapshot, ProcessEntry) then
      begin
        repeat
          if SameText(ProcessEntry.szExeFile, ExeName) then
          begin
            Result := ProcessEntry.th32ProcessID;
            Break;
          end;
        until not Process32Next(Snapshot, ProcessEntry);
      end;
    finally
      CloseHandle(Snapshot);
    end;
end;

class function TAnyDeskRunner.GetAppDataPath: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, 'AnyDesk');
end;

class procedure TAnyDeskRunner.RemoveBackup;
begin
  TDirectory.Delete(TPath.Combine(TPath.GetHomePath, 'AnyDeskRunner'), True);
end;

class procedure TAnyDeskRunner.RemoveServiceConf;
const
  serv_conf = 'C:\ProgramData\AnyDesk\service.conf';
begin
  if TFile.Exists(serv_conf) then
    TFile.Delete(serv_conf);
end;

class procedure TAnyDeskRunner.RestoreUsersAndThumbnails;
var
  LThumbOld, LThumbNew: string;
  LUsersOld, LUsersNew: string;
begin
  LThumbOld := TPath.Combine(GetAppDataPath, 'thumbnails');
  LThumbNew := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'AnyDeskRunner'), 'thumbnails');
  TDirectory.Copy(LThumbNew, LThumbOld);
  LUsersOld := TPath.Combine(GetAppDataPath, 'user.conf');
  LUsersNew := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'AnyDeskRunner'), 'user.conf');
  TFile.Copy(LUsersNew, LUsersOld, True);
end;

class procedure TAnyDeskRunner.RunAnyDesk;
begin
  ShellExecute(0, 'open', ('C:\Program Files (x86)\AnyDesk\AnyDesk.exe'), nil, nil, SW_SHOW);
end;

class procedure TAnyDeskRunner.TerminateAllProcessByName(const ExeName: string);
begin
  while TerminateProcessByName(ExeName) do
    Continue;
end;

class function TAnyDeskRunner.TerminateProcessByName(const ExeName: string): Boolean;
var
  PID: DWORD;
begin
  PID := FindProcessID(ExeName);
  Result := PID <> 0;
  if Result then
    Result := TerminateProcessByPID(PID);
end;

class function TAnyDeskRunner.TerminateProcessByPID(PID: DWORD): Boolean;
var
  hProcess: THandle;
begin
  hProcess := OpenProcess(PROCESS_TERMINATE, FALSE, PID);
  Result := hProcess <> 0;
  if Result then
    try
      TerminateProcess(hProcess, 0);
    finally
      CloseHandle(hProcess);
    end;
end;

end.
