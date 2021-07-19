#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

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

  pack [label .buttons.logo -image [cadenceLogo] -bd 0 -relief flat] \
      -side left -padx 5

  bind . <KeyPress-Return> { .buttons.preview invoke }
  bind . <KeyPress-Escape> { .buttons.cancel invoke }
  bind . <Control-KeyPress-Return> { .buttons.ok invoke }
}

proc cadenceLogo {} {
  set logoData "
R0lGODlhgAAYAPQfAI6MjDEtLlFOT8jHx7e2tv39/RYSE/Pz8+Tj46qoqHl3d+vq62ZjY/n4+NT
T0+gXJ/BhbN3d3fzk5vrJzR4aG3Fubz88PVxZWp2cnIOBgiIeH769vtjX2MLBwSMfIP///yH5BA
EAAB8AIf8LeG1wIGRhdGF4bXD/P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIe
nJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtdGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1w
dGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYxIDY0LjE0MDk0OSwgMjAxMC8xMi8wNy0xMDo1Nzo
wMSAgICAgICAgIj48cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudy5vcmcvMTk5OS8wMi
8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmY6YWJvdXQ9IiIg/3htbG5zO
nhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0
cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUcGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh
0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0idX
VpZDoxMEJEMkEwOThFODExMUREQTBBQzhBN0JCMEIxNUM4NyB4bXBNTTpEb2N1bWVudElEPSJ4b
XAuZGlkOkIxQjg3MzdFOEI4MTFFQjhEMv81ODVDQTZCRURDQzZBIiB4bXBNTTpJbnN0YW5jZUlE
PSJ4bXAuaWQ6QjFCODczNkZFOEI4MTFFQjhEMjU4NUNBNkJFRENDNkEiIHhtcDpDcmVhdG9yVG9
vbD0iQWRvYmUgSWxsdXN0cmF0b3IgQ0MgMjMuMSAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpZW
RGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MGE1NjBhMzgtOTJiMi00MjdmLWE4ZmQtM
jQ0NjMzNmNjMWI0IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjBhNTYwYTM4LTkyYjItNDL/
N2YtYThkLTI0NDYzMzZjYzFiNCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g
6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgH//v38+/r5+Pf29fTz8vHw7+7t7Ovp6Ofm5e
Tj4uHg397d3Nva2djX1tXU09LR0M/OzczLysnIx8bFxMPCwcC/vr28u7q5uLe2tbSzsrGwr66tr
KuqqainpqWko6KhoJ+enZybmpmYl5aVlJOSkZCPjo2Mi4qJiIeGhYSDgoGAf359fHt6eXh3dnV0
c3JxcG9ubWxramloZ2ZlZGNiYWBfXl1cW1pZWFdWVlVUU1JRUE9OTUxLSklIR0ZFRENCQUA/Pj0
8Ozo5ODc2NTQzMjEwLy4tLCsqKSgnJiUkIyIhIB8eHRwbGhkYFxYVFBMSERAPDg0MCwoJCAcGBQ
QDAgEAACwAAAAAgAAYAAAF/uAnjmQpTk+qqpLpvnAsz3RdFgOQHPa5/q1a4UAs9I7IZCmCISQwx
wlkSqUGaRsDxbBQer+zhKPSIYCVWQ33zG4PMINc+5j1rOf4ZCHRwSDyNXV3gIQ0BYcmBQ0NRjBD
CwuMhgcIPB0Gdl0xigcNMoegoT2KkpsNB40yDQkWGhoUES57Fga1FAyajhm1Bk2Ygy4RF1seCjw
vAwYBy8wBxjOzHq8OMA4CWwEAqS4LAVoUWwMul7wUah7HsheYrxQBHpkwWeAGagGeLg717eDE6S
4HaPUzYMYFBi211FzYRuJAAAp2AggwIM5ElgwJElyzowAGAUwQL7iCB4wEgnoU/hRgIJnhxUlpA
SxY8ADRQMsXDSxAdHetYIlkNDMAqJngxS47GESZ6DSiwDUNHvDd0KkhQJcIEOMlGkbhJlAK/0a8
NLDhUDdX914A+AWAkaJEOg0U/ZCgXgCGHxbAS4lXxketJcbO/aCgZi4SC34dK9CKoouxFT8cBNz
Q3K2+I/RVxXfAnIE/JTDUBC1k1S/SJATl+ltSxEcKAlJV2ALFBOTMp8f9ihVjLYUKTa8Z6GBCAF
rMN8Y8zPrZYL2oIy5RHrHr1qlOsw0AePwrsj47HFysrYpcBFcF1w8Mk2ti7wUaDRgg1EISNXVwF
lKpdsEAIj9zNAFnW3e4gecCV7Ft/qKTNP0A2Et7AUIj3ysARLDBaC7MRkF+I+x3wzA08SLiTYER
KMJ3BoR3wzUUvLdJAFBtIWIttZEQIwMzfEXNB2PZJ0J1HIrgIQkFILjBkUgSwFuJdnj3i4pEIlg
eY+Bc0AGSRxLg4zsblkcYODiK0KNzUEk1JAkaCkjDbSc+maE5d20i3HY0zDbdh1vQyWNuJkjXnJ
C/HDbCQeTVwOYHKEJJwmR/wlBYi16KMMBOHTnClZpjmpAYUh0GGoyJMxya6KcBlieIj7IsqB0ji
5iwyyu8ZboigKCd2RRVAUTQyBAugToqXDVhwKpUIxzgyoaacILMc5jQEtkIHLCjwQUMkxhnx5I/
seMBta3cKSk7BghQAQMeqMmkY20amA+zHtDiEwl10dRiBcPoacJr0qjx7Ai+yTjQvk31aws92JZ
Q1070mGsSQsS1uYWiJeDrCkGy+CZvnjFEUME7VaFaQAcXCCDyyBYA3NQGIY8ssgU7vqAxjB4EwA
DEIyxggQAsjxDBzRagKtbGaBXclAMMvNNuBaiGAAA7"

  return [image create photo -format GIF -data $logoData]
}

makeWindow
tkwait window .

#############################################################################
#
# This file is licensed under the Cadence Public License Version 1.0 (the
# "License"), a copy of which is found in the included file named "LICENSE",
# and is distributed "AS IS." TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
# LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO
# ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE.
# Please see the License for the full text of applicable terms.
#
#############################################################################
