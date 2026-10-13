using JetBrains.Annotations;

namespace CarMenuPlugin;

[UsedImplicitly(ImplicitUseKindFlags.Assign, ImplicitUseTargetFlags.WithMembers)]
public class CarMenuConfiguration
{
    // Menuyu acip kapatan tus: F6 (Lua tarafinda sabit, tasarim asamasinda ayara baglanabilir)
    // Menude gosterilmeyecek arac klasor adlari (ornegin trafik/AI arabalari)
    public List<string> ExcludeModels { get; init; } = new();
}
