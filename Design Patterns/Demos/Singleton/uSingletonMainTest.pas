unit uSingletonMainTest;

interface

uses
  Patterns.Singleton,
  SingletonTest.Sucursal,
  SingletonTest.Persona,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls;

type
  // ambas declaraciones son validas
  TSingletonSucursal = TSingleton<TSucursal>;
  TSingletonPersona = class(TSingleton<TPersona>);

  TForm3 = class(TForm)
    edNumero: TLabeledEdit;
    edNombre: TLabeledEdit;
    btnMostrarSucursal: TButton;
    btnMostrarPersona: TButton;
    btnCambiarSucursal: TButton;
    btnCambiarPersona: TButton;
    btnCambiarTrabajador: TButton;
    btnMostrarTrabajador: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnMostrarSucursalClick(Sender: TObject);
    procedure btnMostrarPersonaClick(Sender: TObject);
    procedure btnCambiarSucursalClick(Sender: TObject);
    procedure btnCambiarPersonaClick(Sender: TObject);
    procedure btnMostrarTrabajadorClick(Sender: TObject);
    procedure btnCambiarTrabajadorClick(Sender: TObject);
  private
    procedure MostrarDatosSucursal;
    procedure MostrarDatosPersona;
    procedure MostrarDatosTrabajador;

    procedure CambiarDatosSucursal(const NuevoNumero: Integer; const NuevoNombre: string);
    procedure CambiarDatosPersona(const NuevoNombre: string);
    procedure CambiarDatosTrabajador(const NuevoSalario: Currency;const NuevoNombre: string);
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  SingletonTest.Trabajador,
  Patterns.Singleton.Repository,
  Patterns.Singleton.SpringRepository;

procedure TForm3.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  // uncomment override singletons repository -- doesn't work on Delphi 2010
//  TSingletonRepository.Initialize(TSpringSingletonRepository.Create);
end;

procedure TForm3.btnMostrarPersonaClick(Sender: TObject);
begin
  MostrarDatosPersona;
end;

procedure TForm3.btnMostrarSucursalClick(Sender: TObject);
begin
  MostrarDatosSucursal;
end;

procedure TForm3.btnMostrarTrabajadorClick(Sender: TObject);
begin
  MostrarDatosTrabajador;
end;

procedure TForm3.btnCambiarPersonaClick(Sender: TObject);
begin
  CambiarDatosPersona(edNombre.Text);
end;

procedure TForm3.btnCambiarSucursalClick(Sender: TObject);
begin
  CambiarDatosSucursal(StrToIntDef(edNumero.Text, TSingletonSucursal.Instance.Numero), edNombre.Text);
end;

procedure TForm3.btnCambiarTrabajadorClick(Sender: TObject);
begin
  CambiarDatosTrabajador(StrToCurrDef(edNumero.Text, 0), edNombre.Text);
end;

procedure TForm3.CambiarDatosPersona(const NuevoNombre: string);
begin
  TSingletonPersona.Instance.Nombre := NuevoNombre;
end;

procedure TForm3.CambiarDatosSucursal(const NuevoNumero: Integer; const NuevoNombre: string);
begin
  TSingletonSucursal.Instance.Numero := NuevoNumero;
  TSingletonSucursal.Instance.Nombre := NuevoNombre;
end;

procedure TForm3.CambiarDatosTrabajador(const NuevoSalario: Currency; const NuevoNombre: string);
begin
  TSingleton<TTrabajador>.Instance.Salario := NuevoSalario;
  TSingleton<TTrabajador>.Instance.Nombre := NuevoNombre;
end;

procedure TForm3.MostrarDatosPersona;
begin
  ShowMessageFmt('Persona: %s', [TSingletonPersona.Instance.Nombre]);
end;

procedure TForm3.MostrarDatosSucursal;
begin
  ShowMessageFmt('Sucursal: %d, %s', [TSingletonSucursal.Instance.Numero, TSingletonSucursal.Instance.Nombre]);
end;

procedure TForm3.MostrarDatosTrabajador;
begin
  ShowMessageFmt('Trabajador: %f %s', [TSingleton<TTrabajador>.Instance.Salario, TSingleton<TTrabajador>.Instance.Nombre]);
end;

end.
