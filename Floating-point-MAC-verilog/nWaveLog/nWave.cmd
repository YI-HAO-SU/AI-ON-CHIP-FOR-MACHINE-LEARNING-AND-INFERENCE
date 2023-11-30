wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/AOC2023/aoc2023_050/Lab3/MAC.fsdb}
wvSelectGroup -win $_nWave1 {G1}
wvResizeWindow -win $_nWave1 867 260 960 567
wvMoveSelected -win $_nWave1
wvSelectGroup -win $_nWave1 {G1}
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/MAC_tb"
wvGetSignalSetScope -win $_nWave1 "/MAC_tb/MAC0"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/MAC_tb/MAC0/filter\[7:0\]} \
{/MAC_tb/MAC0/ifmap\[7:0\]} \
{/MAC_tb/MAC0/psum\[23:0\]} \
{/MAC_tb/MAC0/updated_psum\[23:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/MAC_tb/MAC0/filter\[7:0\]} \
{/MAC_tb/MAC0/ifmap\[7:0\]} \
{/MAC_tb/MAC0/psum\[23:0\]} \
{/MAC_tb/MAC0/updated_psum\[23:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvSelectGroup -win $_nWave1 {G1}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 )} 
wvSetRadix -win $_nWave1 -format UDec
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvSetCursor -win $_nWave1 315201.091812 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 110746.329555 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 166119.494333 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 425947.421367 -snap {("G1" 1)}
wvZoom -win $_nWave1 511136.905641 1069128.027631
wvSetCursor -win $_nWave1 601379.026529 -snap {("G1" 1)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvResizeWindow -win $_nWave1 0 23 1920 1057
wvSetCursor -win $_nWave1 552706.588386 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 63330.963253 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 74845.683844 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 207264.970645 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 328169.536854 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 443316.742768 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 264838.573602 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 40301.522070 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 103632.485322 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 259081.213306 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 374228.419220 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 483618.264838 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 667853.794300 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 759971.559031 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 909662.926719 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1099655.816477 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1329950.228304 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1600546.162202 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1744480.169594 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1848112.654916 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 1945987.779943 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 2015076.103491 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 2141738.029997 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 2395061.883007 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 17425143.639502 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 19405675.581219 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 21017736.464012 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 32589032.293972 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 32658120.617521 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 31978752.102629 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 31057574.455319 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 32704179.499886 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 31996024.183516 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 30879096.286153 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 30021249.602095 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 80603.044140 -snap {("G1" 4)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 65.247732 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 56.524773 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 272.505234 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 548.726448 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 309.490579 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 309.490579 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 309.490579 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 309.490579 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 309.490579 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 296.929518 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 272.505234 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 206.559665 -snap {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetRadix -win $_nWave1 -2Com
wvCenterCursor -win $_nWave1
wvSetCursor -win $_nWave1 64.898814 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 65.596650 -snap {("G1" 3)}
wvSetSearchMode -win $_nWave1 -value 
wvSetCursor -win $_nWave1 75.715283 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 46.406141 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 118.632240 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 175.854850 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 175.854850 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 117.585485 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 98.046057 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 172.714585 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 259.944173 -snap {("G1" 4)}
wvSetSearchMode -win $_nWave1 -value 90
wvSearchNext -win $_nWave1
wvSearchNext -win $_nWave1
wvSearchNext -win $_nWave1
wvSearchNext -win $_nWave1
wvSetCursor -win $_nWave1 11520098.866015 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 11520093.632240 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 11520057.693650 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520139.340544 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520140.387299 -snap {("G1" 4)}
wvZoom -win $_nWave1 11520230.408234 11520234.944173
wvSetCursor -win $_nWave1 11520232.073201 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 11519999.773201 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 11519999.773201 -snap {("G1" 1)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 11520100.489529 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520204.104323 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520300.573269 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520498.513255 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520596.411371 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520499.227840 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520595.696786 -snap {("G1" 3)}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetRadix -win $_nWave1 -Mag
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetRadix -win $_nWave1 -2Com
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetRadix -win $_nWave1 -2Com
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetRadix -win $_nWave1 -2Com
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 )} 
wvSetRadix -win $_nWave1 -2Com
wvSelectGroup -win $_nWave1 {G2}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectGroup -win $_nWave1 {G2}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetCursor -win $_nWave1 11520099.060359 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 11520096.916605 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520191.241797 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520292.712836 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520533.527910 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520602.842634 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520746.617093 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520808.071385 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 11520895.250729 -snap {("G1" 3)}
wvSetSearchMode -win $_nWave1 -value -90
wvSearchNext -win $_nWave1
wvSetSearchMode -win $_nWave1 -value -89
wvSearchNext -win $_nWave1
wvSetCursor -win $_nWave1 21375711.665028 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 21375805.990220 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 21376404.097687 -snap {("G2" 0)}
wvExit
