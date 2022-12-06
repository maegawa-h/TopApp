# メイン関数
function _main {

    $base_dir = (Convert-Path .)
    $src_dir = $base_dir + "\src"

    # cprojファイルのバージョン情報の更新
    Push-Location $src_dir
        foreach ($dir in $(Get-ChildItem * | ? { $_.PSIsContainer }))
        {
            Push-Location $dir
            foreach ($file in $(Get-ChildItem *.csproj -Recurse))
            {
                Write-Host $file
                if($file | Test-Path)
                {
                    updataOwnVersion($file)
                    updataReferenceVersion($file)
                }

                Write-Host ""
            }
            Pop-Location
        }
    Pop-Location

    git config core.filemode false

    git add --update
    git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"
    git config --local user.name "github-actions[bot]"
    git commit -m "Commit updated files"
    git push
}

# 自身のバージョン更新
function updataOwnVersion($filePath) {
    $xml_doc = [xml](cat $filePath -enc utf8)
    $xml_nav = $xml_doc.CreateNavigator()

    # ライブラリバージョンの更新
    $libver = $xml_nav.Select("/Project/PropertyGroup/Version")

    $majVer,$minVer,$bldVer = ([string]$libver).Split(".")
    $majVer = [int]([int]$majVer+1);

    $newver = [string]$majVer + "." + $minVer + "." + $bldVer

#    Write-Host $newver;

    $libver.SetValue($newver);

    $xml_doc.Save($filePath)
}

# 参照のバージョン更新
function updataReferenceVersion($filePath) {
    # 参照パッケージのバージョン情報の更新
    $xml_doc = [xml](cat $filePath -enc utf8)
    $xml_nav = $xml_doc.CreateNavigator()

    $nodes = $xml_nav.Select("/Project/ItemGroup/PackageReference")
    While ($nodes.MoveNext()) # MoveNext()メソッドによる値の取り出し
    {
        $Matches.Clear()
        try
        {
            $libName = $nodes.Current.getattribute("Include", "")
            $v=[string](gh release view -R https://github.com/maegawa-h/$libName)
            $v -match 'tag:\s(?<version>.*?)\s' >> $null
            $version = $nodes.Current.Select("./@Version")

            if ($Matches.version)
            {
                $version.SetValue($Matches.version)
                Write-Host [M]$libName reference version: $Matches.version;
            }
        }
        catch
        {
        
        }
    }
    $xml_doc.Save($filePath)
}

_main
