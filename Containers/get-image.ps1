function GetImages {    
    param(
        [string] $name
    )

    $re = "^(?<repo>[A-Za-z0-9\./-]+)(?:\W+)(?<tag>[A-Za-z0-9\./-]+)(?:\W+)(?<imageId>[a-z0-9]+)(?:.*)"

    $imageReport = docker image ls

    $imageStrings = $imageReport | Select-String -Pattern $re 

    $numImages = $imageStrings.Length-1
    $images = [Object[]]::new($numImages) 

    $i = 0;
    foreach ($item in $imageStrings) {
        if ($i -gt 0) {
            $repo, $tag, $imageId = $item.Matches[0].Groups[1..3].Value 

            $images[$i-1] = [PSCustomObject] @{
                Repo = $repo
                Tag = $tag
                ImageId = $imageId 
            }
        }
        $i++
    }
    if ($null -ne $name) {
        $images = $images | Where-Object -Like -Property Repo -Value "*$name*" 
    }    
    return $images
}

# $searchStr = "samplewebapi2"
# $searchStr = "desktop-kubernetes"

# GetImages -name "kube"
GetImages -name "dotnet"
