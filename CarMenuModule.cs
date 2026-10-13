using Autofac;
using AssettoServer.Server.Plugin;

namespace CarMenuPlugin;

public class CarMenuModule : AssettoServerModule<CarMenuConfiguration>
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<CarMenuService>().AsSelf().As<IAssettoServerAutostart>().SingleInstance();
    }
}
