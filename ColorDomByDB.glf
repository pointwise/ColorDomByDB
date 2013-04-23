#
# Copyright 2009 (c) Pointwise, Inc.
# All rights reserved.
# 
# This sample Pointwise script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.  
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

###############################################################################
##
## ColorDomByDB.glf
##
## Script with Tk interface to set domain colors by their database associativity
##
###############################################################################

package require PWI_Glyph 2

pw::Script loadTk


set Color(ALL) #FF0000
set Color(SOME) #FF8888
set Color(NONE) #00FFFF

foreach dom [pw::Grid getAll -type pw::Domain] {
  set SaveStyles($dom) [list [$dom getColor] \
    [$dom getRenderAttribute SecondaryColor] \
    [$dom getRenderAttribute ColorMode]]
}

############################################################################
# restoreColors: restore original domain colors
############################################################################
proc restoreColors { } {
  global SaveStyles
  foreach dom [array names SaveStyles] {
    $dom setColor [lindex $SaveStyles($dom) 0]
    $dom setRenderAttribute SecondaryColor [lindex $SaveStyles($dom) 1]
    $dom setRenderAttribute ColorMode [lindex $SaveStyles($dom) 2]
  } 
}

############################################################################
# getAssociativity: get domain db associativity
############################################################################
proc getAssociativity { dom } {
  set exam [pw::Examine create DomainOnDatabase]
  $exam addEntity $dom
  $exam setRangeLimits 0.5 0.5
  $exam examine
  if { [$exam getBelowRange] == 0 } {
    set result ALL
  } elseif { [$exam getAboveRange] == 0 } {
    set result NONE
  } else {
    set result SOME
  }
  $exam delete
  return $result
}

############################################################################
# setColors: color domains by their associativity
############################################################################
proc setColors { } {
  global Color colors
  foreach dom [pw::Grid getAll -type pw::Domain] {
    set associativity [getAssociativity $dom]
    $dom setColor $Color($associativity)
    $dom setRenderAttribute SecondaryColor $Color($associativity)
    $dom setRenderAttribute ColorMode Entity
  }  
  pw::Display update
}

############################################################################
# makeWindow: create the Tk window
############################################################################
proc makeWindow { } {
  global Color colors

  wm title . "Color Domains By Associativity"

  label .title -text "Color Domains By DB Associativity"
  set font [font actual [.title cget -font] -family]
  .title configure -font [font create -family $font -weight bold]
  pack .title -expand 1 -side top

  pack [frame .hr1 -relief sunken -height 2 -bd 1] \
    -side top -padx 2 -fill x -pady 1
  pack [frame .inputs] -padx 2

  grid [label .lblALL -text "All Points:" -justify right] -in .inputs \
    -column 0 -row 0 -sticky e
  grid [label .lblSOME -text "Some Points:" -justify right] -in .inputs \
    -column 0 -row 1 -sticky e
  grid [label .lblNONE -text "No Points:" -justify right] -in .inputs \
    -column 0 -row 2 -sticky e

  button .pickALL -text ">" -command {
    set c [tk_chooseColor -initialcolor $Color(ALL) -parent . \
      -title "All Points Color"]
    if [string length $c] {
      set Color(ALL) $c
      .sampleALL configure -background $Color(ALL)
    }
  }
  grid .pickALL -in .inputs -padx 5 -column 1 -row 0

  button .pickSOME -text ">" -command {
    set c [tk_chooseColor -initialcolor $Color(SOME) -parent . \
      -title "Some Points Color"]
    if [string length $c] {
      set Color(SOME) $c
      .sampleSOME configure -background $Color(SOME)
    }
  }
  grid .pickSOME -in .inputs -padx 5 -column 1 -row 1

  button .pickNONE -text ">" -command {
    set c [tk_chooseColor -initialcolor $Color(NONE) -parent . \
      -title "No Points Color"]
    if [string length $c] {
      set Color(NONE) $c
      .sampleNONE configure -background $Color(NONE)
    }
  }
  grid .pickNONE -in .inputs -padx 5 -column 1 -row 2

  grid [frame .sampleALL -width 1c -height .5c] -in .inputs -column 2 -row 0
  grid [frame .sampleSOME -width 1c -height .5c] -in .inputs -column 2 -row 1
  grid [frame .sampleNONE -width 1c -height .5c] -in .inputs -column 2 -row 2
  .sampleALL configure -background $Color(ALL)
  .sampleSOME configure -background $Color(SOME)
  .sampleNONE configure -background $Color(NONE)

  pack [frame .hr2 -relief sunken -height 2 -bd 1] \
    -side top -padx 2 -fill x -pady 1

  pack [frame .buttons] -fill x -padx 2 -pady 1
  pack [button .buttons.preview -text "Preview" -command {
      wm withdraw .
      setColors
      if [winfo exists .] {
        wm deiconify .
      }
    }] -side right -padx 2

  pack [button .buttons.cancel -text "Cancel" \
    -command { restoreColors; exit }] -side right -padx 2
  pack [button .buttons.ok -text "OK" -command { setColors; exit }] \
    -side right -padx 2

  pack [label .buttons.logo -image [pwLogo] -bd 0 -relief flat] \
      -side left -padx 5

  bind . <KeyPress-Return> { .buttons.preview invoke }
  bind . <KeyPress-Escape> { .buttons.cancel invoke }
  bind . <Control-KeyPress-Return> { .buttons.ok invoke }
}

proc pwLogo {} {
  set logoData "
R0lGODlheAAYAIcAAAAAAAICAgUFBQkJCQwMDBERERUVFRkZGRwcHCEhISYmJisrKy0tLTIyMjQ0
NDk5OT09PUFBQUVFRUpKSk1NTVFRUVRUVFpaWlxcXGBgYGVlZWlpaW1tbXFxcXR0dHp6en5+fgBi
qQNkqQVkqQdnrApmpgpnqgpprA5prBFrrRNtrhZvsBhwrxdxsBlxsSJ2syJ3tCR2siZ5tSh6tix8
ti5+uTF+ujCAuDODvjaDvDuGujiFvT6Fuj2HvTyIvkGKvkWJu0yUv2mQrEOKwEWNwkaPxEiNwUqR
xk6Sw06SxU6Uxk+RyVKTxlCUwFKVxVWUwlWWxlKXyFOVzFWWyFaYyFmYx16bwlmZyVicyF2ayFyb
zF2cyV2cz2GaxGSex2GdymGezGOgzGSgyGWgzmihzWmkz22iymyizGmj0Gqk0m2l0HWqz3asznqn
ynuszXKp0XKq1nWp0Xaq1Hes0Xat1Hmt1Xyt0Huw1Xux2IGBgYWFhYqKio6Ojo6Xn5CQkJWVlZiY
mJycnKCgoKCioqKioqSkpKampqmpqaurq62trbGxsbKysrW1tbi4uLq6ur29vYCu0YixzYOw14G0
1oaz14e114K124O03YWz2Ie12oW13Im10o621Ii22oi23Iy32oq52Y252Y+73ZS51Ze81JC625G7
3JG825K83Je72pW93Zq92Zi/35G+4aC90qG+15bA3ZnA3Z7A2pjA4Z/E4qLA2KDF3qTA2qTE3avF
36zG3rLM3aPF4qfJ5KzJ4LPL5LLM5LTO4rbN5bLR6LTR6LXQ6r3T5L3V6cLCwsTExMbGxsvLy8/P
z9HR0dXV1dbW1tjY2Nra2tzc3N7e3sDW5sHV6cTY6MnZ79De7dTg6dTh69Xi7dbj7tni793m7tXj
8Nbk9tjl9N3m9N/p9eHh4eTk5Obm5ujo6Orq6u3t7e7u7uDp8efs8uXs+Ozv8+3z9vDw8PLy8vL0
9/b29vb5+/f6+/j4+Pn6+/r6+vr6/Pn8/fr8/Pv9/vz8/P7+/gAAACH5BAMAAP8ALAAAAAB4ABgA
AAj/AP8JHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNqZCioo0dC0Q7Sy2btlitisrjpK4io4yF/
yjzKRIZPIDSZOAUVmubxGUF88Aj2K+TxnKKOhfoJdOSxXEF1OXHCi5fnTx5oBgFo3QogwAalAv1V
yyUqFCtVZ2DZceOOIAKtB/pp4Mo1waN/gOjSJXBugFYJBBflIYhsq4F5DLQSmCcwwVZlBZvppQtt
D6M8gUBknQxA879+kXixwtauXbhheFph6dSmnsC3AOLO5TygWV7OAAj8u6A1QEiBEg4PnA2gw7/E
uRn3M7C1WWTcWqHlScahkJ7NkwnE80dqFiVw/Pz5/xMn7MsZLzUsvXoNVy50C7c56y6s1YPNAAAC
CYxXoLdP5IsJtMBWjDwHHTSJ/AENIHsYJMCDD+K31SPymEFLKNeM880xxXxCxhxoUKFJDNv8A5ts
W0EowFYFBFLAizDGmMA//iAnXAdaLaCUIVtFIBCAjP2Do1YNBCnQMwgkqeSSCEjzzyJ/BFJTQfNU
WSU6/Wk1yChjlJKJLcfEgsoaY0ARigxjgKEFJPec6J5WzFQJDwS9xdPQH1sR4k8DWzXijwRbHfKj
YkFO45dWFoCVUTqMMgrNoQD08ckPsaixBRxPKFEDEbEMAYYTSGQRxzpuEueTQBlshc5A6pjj6pQD
wf9DgFYP+MPHVhKQs2Js9gya3EB7cMWBPwL1A8+xyCYLD7EKQSfEF1uMEcsXTiThQhmszBCGC7G0
QAUT1JS61an/pKrVqsBttYxBxDGjzqxd8abVBwMBOZA/xHUmUDQB9OvvvwGYsxBuCNRSxidOwFCH
J5dMgcYJUKjQCwlahDHEL+JqRa65AKD7D6BarVsQM1tpgK9eAjjpa4D3esBVgdFAB4DAzXImiDY5
vCFHESko4cMKSJwAxhgzFLFDHEUYkzEAG6s6EMgAiFzQA4rBIxldExBkr1AcJzBPzNDRnFCKBpTd
gCD/cKKKDFuYQoQVNhhBBSY9TBHCFVW4UMkuSzf/fe7T6h4kyFZ/+BMBXYpoTahB8yiwlSFgdzXA
5JQPIDZCW1FgkDVxgGKCFCywEUQaKNitRA5UXHGFHN30PRDHHkMtNUHzMAcAA/4gwhUCsB63uEF+
bMVB5BVMtFXWBfljBhhgbCFCEyI4EcIRL4ChRgh36LBJPq6j6nS6ISPkslY0wQbAYIr/ahCeWg2f
ufFaIV8QNpeMMAkVlSyRiRNb0DFCFlu4wSlWYaL2mOp13/tY4A7CL63cRQ9aEYBT0seyfsQjHedg
xAG24ofITaBRIGTW2OJ3EH7o4gtfCIETRBAFEYRgC06YAw3CkIqVdK9cCZRdQgCVAKWYwy/FK4i9
3TYQIboE4BmR6wrABBCUmgFAfgXZRxfs4ARPPCEOZJjCHVxABFAA4R3sic2bmIbAv4EvaglJBACu
IxAMAKARBrFXvrhiAX8kEWVNHOETE+IPbzyBCD8oQRZwwIVOyAAXrgkjijRWxo4BLnwIwUcCJvgP
ZShAUfVa3Bz/EpQ70oWJC2mAKDmwEHYAIxhikAQPeOCLdRTEAhGIQKL0IMoGTGMgIBClA9QxkA3U
0hkKgcy9HHEQDcRyAr0ChAWWucwNMIJZ5KilNGvpADtt5JrYzKY2t8nNbnrzm+B8SEAAADs="

  return [image create photo -format GIF -data $logoData]
}

makeWindow
tkwait window .

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED 
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY 
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE 
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE 
# FAULT OR NEGLIGENCE OF POINTWISE.
#

