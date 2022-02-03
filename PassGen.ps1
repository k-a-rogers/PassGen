##############################
#
# Function declarations
#
##############################

function New-Password {
    # Initialise password variable
    [string]$global:password=$null

     while (($global:password.Length -lt $reqlength) -or (!$global:lower) -or (!$global:upper) -or (!$int) -or (!$global:special)) {
		$select=Get-Random -Minimum 1 -Maximum 5
		switch ($select) {
			"1" {
				New-Char -Chartype "Lower"
				[boolean]$global:lower=$true
			}
			"2" {
				New-Char -Chartype "Upper"
				[boolean]$global:upper=$true
			}
			"3" {
				New-Char -Chartype "Int"
				[boolean]$global:int=$true
			}
			"4" {
				New-Char -Chartype "Special"
				[boolean]$global:special=$true
			}
		}
    }
	Remove-Variable -Name select,upper,lower,int,special -Force -ErrorAction SilentlyContinue
}

function New-Passphrase {
	Param(
		[Parameter(Mandatory=$true)]  
		[String]$wordlist
	)
	Remove-Variable -Name lower,upper,int,special -Force -ErrorAction SilentlyContinue
	switch ($wordlist) {
		"Simple" {
			$dictionary=Get-Content -Path $($PSScriptroot+"\Ogden_basic_dictionary.txt") | ? {$_.Length -gt 4}
			[boolean]$complex=$false
			[boolean]$global:special=$true
		}
		"Common" {
			$dictionary=Get-Content -Path $($PSScriptroot+"\MIT_common_dictionary.txt")
			[boolean]$complex=$false
			[boolean]$global:special=$true
		}
		"Strong" {
			$dictionary=Get-Content -Path $($PSScriptroot+"\EFF_large_dictionary.txt")
			[boolean]$complex=$true
		}
	}
	
    # Initialise password variable
    [string]$global:password=$null

	# The password is started with a word.
	$seed=Get-Random -minimum 0 -maximum $dictionary.count
	$global:password+=(Get-Culture).TextInfo.ToTitleCase($dictionary[$seed])

    while (($global:password.Length -lt $reqlength) -or (!$global:int) -or (!$global:special)) {
		$select=Get-Random -Minimum 1 -Maximum 4
		switch ($select) {
			"1" {
				# Add special character
				if ($complex -and (!$global:special)) {
					New-Char -chartype "Special"
					[boolean]$global:special=$true
				}
			}
			"2" {
				# Add number if one is not already present
				if (!$global:int) {
					New-Char -chartype "Int"
					[boolean]$global:int=$true
				}
			}
			"3" {
				$seed=Get-Random -minimum 0 -maximum $dictionary.count
				# Get-Culture is used to capitalise the first letter of each word, for ease of legibility
				$global:password+=(Get-Culture).TextInfo.ToTitleCase($dictionary[$seed])
				Remove-Variable -Name seed -Force -ErrorAction SilentlyContinue
			}
		}
    }
	Remove-Variable -Name dictionary,select,int,special -Force -ErrorAction SilentlyContinue
}

function New-Char {
	Param(
		[Parameter(Mandatory=$true)]  
		[String]$chartype
	)
	switch ($chartype) {
		"Lower" {
		    $global:password+=($global:charpool[(Get-Random -minimum 0 -maximum $global:charpool.count)]).ToLower()
		}
		"Upper" {
		    $global:password+=$global:charpool[(Get-Random -minimum 0 -maximum $global:charpool.count)]
		}
		"Int" {
			$global:password+=(Get-Random -Minimum 10 -Maximum 100)
		}
		"Special" {
		    $global:password+=$global:specialpool[(Get-Random -minimum 0 -maximum $global:specialpool.count)]
		}
	}
	Remove-Variable -Name seed -force -erroraction silentlycontinue
}

############################
#
# Main body 
#
############################


# Define a set of character pools of  pulled from the strong password complexity requirements 
$global:charpool=@("A","B","C","D","E","F","G","H","J","K","M","N","P","Q","R","S","T","U","V","W","X","Y","Z")
$global:specialpool=@("(",")","!","@","$","&","*","-","+","=",".","?")

# Define  required password length to ensure internal consistency.
[int]$reqlength=16

# UI created with native .NET methods
Function Native-GUI {
	Add-Type -assembly System.Windows.Forms
	$form = New-Object System.Windows.Forms.Form

	# Set the properties for the main program window 
	# $form.Text="Password Generator" (this would set the titlebar name, if desired)
	$form.Autosize=$true
	# If desired, hard-coded windows size can be set as well
	# $form.Height=400
	# $form.Width=400
	$form.BackColor="White"
	$buttonwidth=$($form.Size.Width)

	# Create the program name displayed within the window
	$proglabel= New-Object System.Windows.Forms.Label
	$proglabel.text= "Passphrase Generator"
	$proglabel.autosize=$true
	$startingpoint=($form.Width/2)-($proglabel.Width/2)
	$proglabel.location=New-Object System.Drawing.Point($startingpoint,0)
	$form.Controls.Add($proglabel)

	# Create the buttons for interacting with the program:
	## Button 1
	$button1=New-Object System.Windows.Forms.Button
	$button1.Location=New-object System.Drawing.Point(0,20)
	$button1.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button1.Text="New complex password"
	$button1.textAlign="MiddleCenter"
	$button1.BackColor="LightGray"
	$button1.Add_Click(
		{
			New-Password
			$PasswordLabel.Text=$global:password
			[boolean]$global:lower=$false
			[boolean]$global:upper=$false
			[boolean]$global:int=$false
			[boolean]$global:special=$false
		}
	)
	$form.Controls.Add($button1)
	## Button 2
	$button2=New-Object System.Windows.Forms.Button
	$button2.Location=New-object System.Drawing.Point(0,40)
	$button2.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button2.Text="New simple passphrase"
	$button2.textAlign="MiddleCenter"
	$button2.BackColor="LightGray"
	$button2.Add_Click(
		{
			New-Passphrase -wordlist "Simple"
			if ($global:password.Length -gt $($reqlength+10)) {
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
				New-Passphrase -wordlist "Simple"
			}
			$PasswordLabel.Text=$global:password
			[boolean]$global:lower=$false
			[boolean]$global:upper=$false
			[boolean]$global:int=$false
			[boolean]$global:special=$false
		}
	)
	$form.Controls.Add($button2)
	## Button 3
	$button3=New-Object System.Windows.Forms.Button
	$button3.Location=New-object System.Drawing.Point(0,60)
	$button3.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button3.Text="New common-word passphrase"
	$button3.textAlign="MiddleCenter"
	$button3.BackColor="LightGray"
	$button3.Add_Click(
		{
			New-Passphrase -wordlist "Strong"
			if ($global:password.Length -gt $($reqlength+10)) {
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
				New-Passphrase -wordlist "Common"
			}
			$PasswordLabel.Text=$global:password
			[boolean]$global:lower=$false
			[boolean]$global:upper=$false
			[boolean]$global:int=$false
			[boolean]$global:special=$false
		}
	)
	$form.Controls.Add($button3)
	
	## Button 4
	$button4=New-Object System.Windows.Forms.Button
	$button4.Location=New-object System.Drawing.Point(0,80)
	$button4.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button4.Text="New strong passphrase"
	$button4.textAlign="MiddleCenter"
	$button4.BackColor="LightGray"
	$button4.Add_Click(
		{
			New-Passphrase -wordlist "Strong"
			if ($global:password.Length -gt $($reqlength+10)) {
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
				New-Passphrase -wordlist "Strong"
			}
			$PasswordLabel.Text=$global:password
			[boolean]$global:lower=$false
			[boolean]$global:upper=$false
			[boolean]$global:int=$false
			[boolean]$global:special=$false
		}
	)
	$form.Controls.Add($button4)
	## Button 5
	$button5=New-Object System.Windows.Forms.Button
	$button5.Location=New-object System.Drawing.Point(0,100)
	$button5.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button5.Text="Copy to clipboard"
	$button5.textAlign="MiddleCenter"
	$button5.BackColor="LightGray"
	$button5.Add_Click(
		{
			try {
				Get-Command Set-Clipboard -ErrorAction Stop | out-null
				Set-Clipboard -Value $global:password
			} catch {
				[Windows.Forms.Clipboard]::SetText($global:password)
			}
		}
	)
	$form.Controls.Add($button5)
	## Button 6
	$button6=New-Object System.Windows.Forms.Button
	$button6.Location=New-object System.Drawing.Point(0,120)
	$button6.Size=New-Object System.drawing.Size($buttonwidth,18)
	$button6.Text="Quit"
	$button6.textAlign="MiddleCenter"
	$button6.BackColor="LightGray"
	$button6.Add_Click(
		{
			$form.close()
		}
	)
	$form.Controls.Add($button6)

	# Create the label which will be used to display the generated password
	$PasswordLabel = New-Object System.Windows.Forms.Label
	$PasswordLabel.text= "Click a button to generate a password!"
	$PasswordLabel.location=New-Object System.Drawing.Point(0,150)
	$PasswordLabel.autosize=$true
	$form.Controls.Add($PasswordLabel)

	# Display the form.
	$form.ShowDialog()
}

Function ShowUI-GUI {
	ipmo showui
	Show-UI {
		StackPanel -Margin 5 {
			TextBlock "Password generator" -FontWeight Bold -Fontsize 32
			Button -Margin 2 "New complex password" -On_Click {
				New-Password
				$PasswordLabel.Content=$global:password
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false

			}
			Button -Margin 2 "New simple passphrase" -On_Click {
				New-Passphrase -wordlist "Simple"
				if ($global:password.Length -gt $($reqlength+10)) {
					[boolean]$global:lower=$false
					[boolean]$global:upper=$false
					[boolean]$global:int=$false
					[boolean]$global:special=$false
					New-Passphrase -wordlist "Simple"
				}
				$PasswordLabel.Content=$global:password
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
			}
			Button -Margin 2 "New common-word passphrase" -On_Click {
				New-Passphrase -wordlist "Common"
				if ($global:password.Length -gt $($reqlength+10)) {
					[boolean]$global:lower=$false
					[boolean]$global:upper=$false
					[boolean]$global:int=$false
					[boolean]$global:special=$false
					New-Passphrase -wordlist "Common"
				}
				$PasswordLabel.Content=$global:password
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
			}
			Button -Margin 2 "New strong passphrase" -On_Click {
				New-Passphrase -wordlist "Strong"
				if ($global:password.Length -gt $($reqlength+10)) {
					[boolean]$global:lower=$false
					[boolean]$global:upper=$false
					[boolean]$global:int=$false
					[boolean]$global:special=$false
					New-Passphrase -wordlist "Strong"
				}
				$PasswordLabel.Content=$global:password
				[boolean]$global:lower=$false
				[boolean]$global:upper=$false
				[boolean]$global:int=$false
				[boolean]$global:special=$false
			}
			Button -Margin 2 "Copy to clipboard" -On_Click {
				try {
					Get-Command Set-Clipboard -ErrorAction Stop;
					Set-Clipboard -Value $global:password
				} catch {
					$global:password | clip
				}
			}
			Button -Margin 2 "Quit" -On_Click {
				$window.close()
			}
			Label "Click a button to generate a password!" -Name PasswordLabel
		}
	}
}

Function Text-Menu {

$menutext=@"
Password Generator

1. Generate a new complex password.
2. Generate a new simple passphrase.
3. Generate a new common-word passphrase.
4. Generate a new strong passphrase.
5. Show last generated password
6. Quit.
"@

	[boolean]$quit=$false
	while (!$quit) {
		Clear-Host
		Write-Host $menutext
		[boolean]$global:lower=$false
		[boolean]$global:upper=$false
		[boolean]$global:int=$false
		[boolean]$global:special=$false
		
		$menuchoice=Read-Host("Please enter a choice from the above options")
		switch ($menuchoice) {
			"1" {
				# New conventional password
				New-Password
				Write-Host $global:password
				Read-Host("Press any key to continue")
			}
			"2" {
				# New simple passphrase (Ogden word list)
				New-Passphrase -wordlist "Simple"
				Write-Host $global:password
				Read-Host("Press any key to continue")
			}
			"3" {
				# New common passphrase (MIT 10K most common words list)
				New-Passphrase -wordlist "Common"
				Write-Host $global:password
				Read-Host("Press any key to continue")
			}
			"4" {
				# New strong passphrase (EFF long word list)
				New-Passphrase -wordlist "Strong"
				Write-Host $global:password
				Read-Host("Press any key to continue")
			}
			"5" {
				Write-Host $global:password
				Read-Host("Press any key to continue")
			}
			"6" {
				# Quit
				$quit=$true
			}
			default {
				Write-Host "Invalid choice entered, please try again." -foregroundcolor red
				Start-sleep 3
			}
		}
		
	}
}