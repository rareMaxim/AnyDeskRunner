program AnyDeskRun;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  AnyDesk.Core in 'AnyDesk.Core.pas',
  System.Console in 'System.Console.pas';

procedure Main;
begin
  Console.WriteColorLine('Remove backups', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RemoveBackup;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Close AnyDesk.exe', [TConsoleColor.Blue]);
  try
    if not TAnyDeskRunner.TerminateProcessByName('AnyDesk.exe') then
      Console.WriteColorLine('Cant find runned AnyDesk.exe', [TConsoleColor.Yellow]);
    TAnyDeskRunner.TerminateAllProcessByName('AnyDesk.exe');
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;

  Console.WriteColorLine('Remove service.conf', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RemoveServiceConf;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Dump users and Thumbnails', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.DumpUsersAndThumbnails;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Run anydesk', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RunAnyDesk;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Sleep 10 sec', [TConsoleColor.Blue]);
  Sleep(10 * 1000);
  Console.WriteColorLine('Close AnyDesk.exe', [TConsoleColor.Blue]);
  try
    if not TAnyDeskRunner.TerminateProcessByName('AnyDesk.exe') then
      Console.WriteColorLine('Cant find runned AnyDesk.exe', [TConsoleColor.Yellow]);
    TAnyDeskRunner.TerminateAllProcessByName('AnyDesk.exe');
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Restore users and Thumbnails', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RestoreUsersAndThumbnails;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Remove backups', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RemoveBackup;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
  Console.WriteColorLine('Run anydesk', [TConsoleColor.Blue]);
  try
    TAnyDeskRunner.RunAnyDesk;
  except
    on E: Exception do
      Console.WriteColorLine(E.ToString, [TConsoleColor.White, TConsoleColor.Red]);
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Main;
//    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
