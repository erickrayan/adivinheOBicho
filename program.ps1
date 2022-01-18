$dados = Get-content dado.txt #vari��vel recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal voc� est� pensando.`n`n`n" #frase de efeiton
$global:numeropadronizado=""
[string]$global:simounao=""
[int]$global:linhaDaPergunta=99999


function exibe{#exibe o segundo campo da linha, sendo pergunta ou resposta

    $pergunta = $linha[4]#recebe a primeira letra do texto da pergunta
    $cont = 5
    while ($linha[$cont] -ne "|") {#adiciona caracter por caracter dentro da vari�vel pergunta
        $pergunta += $linha[$cont]
        $cont++
    }

    Write-Output "$pergunta" #Sa�da para o usu�rio

}

function achaLinha([string]$s){#acha o �ndice no arquivo texto que cont�m o texto em quest�o
    $s1= $s[0] + $s[1] + $s[2]
    return ([int]$s1) -1
}

function achaUltima{ #acha o �ndice da �ltima linha ignorando linhas em branco
    $i=0
    [int]$u=0
    foreach ($candidato in $dados){
        if ($candidato.Length -gt 2){ #2? verificar
            $u=$i
        }
        $i++
    }
    return $u
}



function resposta {
    Write-Output "O animal que voc� escolheu �:"
    exibe
    Write-Output "Acertei?"
    $x= Read-Host "Digite `"S`" para SIM, `"N`" para N�O"
    if($x -eq "s" -or $x -eq "S"){
        Write-Output "Obrigado por jogar!"
        pause
        exit
    }
    else{#caso o aplicativo tenha errado a resposta final dada ao usu�rio
        $nomeAnimal= Read-Host "Digite o nome do animal que voc� estava pensando"
        if($nomeAnimal.Length -lt 1){
            do{
            Write-Output "Entrada inv�lida, necess�rio pelo menos 1 caractere"
            $nomeAnimal= Read-Host "Digite o nome do animal que voc� estava pensando"
            }while($nomeAnimal.Length -lt 1)
        }

        $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-n�o que diferencie esse animal do animal citado anteriormente"
        if($pergunta.Length -lt 1){
            do{
            Write-Output "Entrada inv�lida, necess�rio pelo menos 1 caractere"
            $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-n�o que diferencie esse animal do animal citado anteriormente"
            }while($nomeAnimal.Length -lt 1)
        }

        $simnaopergunta= Read-Host "Para o animal que voc� acabou de digitar, a resposta dessa pergunta � sim ou n�o? `n Digite `"S`" para SIM, `"N`" para N�O"
        if($simnaopergunta.Length -lt 1){
            do{
            Write-Output "Entrada inv�lida, necess�rio pelo menos 1 caractere"
            $simnaopergunta= Read-Host "Para o animal que voc� acabou de digitar, a resposta dessa pergunta � sim ou n�o? `n Digite `"S`" para SIM, `"N`" para N�O"
            }while($nomeAnimal.Length -lt 1)
        }

        [int]$ultima=achaUltima
        [string]$valor=""#comporta os n�meros padronizados do �ndice da �ltima linha do texto
        $valor=$dados[$ultima][0] + $dados[$ultima][1] + $dados[$ultima][2]
        
        [int]$proximaresposta=$ultima + 3
        [int]$proximapergunta=$ultima + 2

        padroniza $proximapergunta
        $linhareconstruida= reconstruir $global:numeropadronizado


        #esta parte do c�digo se faz desnecess�ria ao se fazer poss�vel retorno de fun��es
        [string]$r="" #vari�vel tempor�ria
        [int]$n=$proximaresposta #vari�vel tempor�ria #talvez $n seja desnecess�ria
        $r=([string]$n).PadLeft(3,'0') #padroniza o int em uma string de 3 caracteres

        
        if ($simnaopergunta -eq "n" -or $simnaopergunta -eq "N"){
            $dados = $dados + "$global:numeropadronizado|$pergunta|$temp|$r|" #nova pergunta inserida
        }
        else{#posteriormente adicionar c�digo para impedir o usu�rio de digtar uma entrada inv�lida
            $dados = $dados + "$global:numeropadronizado|$pergunta|$r|$temp|"
        }
        
        $dados = $dados + "$r|$nomeAnimal|*|*|" #novo animal inserido

        $dados[$global:linhaDaPergunta]=$linhareconstruida
        Clear-Content -Path dado.txt #limpa o arquivo texto
        Add-Content -Value $dados -Path dado.txt
        
    }
}
function reconstruir ([string]$s){#reconstroi a linha da �ltima pergunta para mudar os �ndice 
#Esta fun��o pode ser eliminada quando eu encontrar um jeito de mudar caracteres individuais de uma string

    $temp=$dados[$global:linhaDaPergunta]
    $t=""
    $cont=0
    while ($cont -ne $temp.Length-9) {#adiciona caracter por caracter dentro da vari�vel t
        $t+=$temp[$cont]
        $cont++
    }

    $camposim=$temp[$temp.Length-8]
    $camposim+=$temp[$temp.Length-7]
    $camposim+=$temp[$temp.Length-6]

    $camponao=$temp[$temp.Length-4]
    $camponao+=$temp[$temp.Length-3]
    $camponao+=$temp[$temp.Length-2]

    
    
    if($global:simounao -eq "s"){
        $camposim=$s
    }
    else {
        $camponao=$s
    }
    
    $recons="$t|$camposim|$camponao|"
    return $recons
    #$global:linhareconstruida="$t|$camposim|$camponao|"
}

function padroniza ([int]$numero){#recebe um inteiro e o padroniza em string com zeros � esquerda #eliminar essa fun��o depois
    $global:numeropadronizado=([string]$numero).PadLeft(3,'0')
}
     





#In�cio da aplica��o
foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta
    break }       
}

    [string]$temp=""
    $interruptor=0
    while ($interruptor -eq 0){

        #cls
        if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta

            $indice=achaLinha $linha
            $global:linhaDaPergunta=$indice #salva o �ndice da pergunta onde o programa est�
            #serve para modificar a pergunta posteriormente
        
            exibe
            $global:simounao= Read-Host "Digite `"S`" para SIM, `"N`" para N�O ou digite `"F`" para finalizar"
            switch ($global:simounao){
            "s"{ #Caso o usu�rio responda sim para a pergunta

                $temp=$linha[$linha.Length-8] #adiciona o campo que cont�m o n�mero da linha na vari�vel temp
                $temp+=$linha[$linha.Length-7]
                $temp+=$linha[$linha.Length-6]
                $indice=achaLinha $temp
                $linha=$dados[$indice]
            }

            "n" { #Caso o usu�rio responda n�o para a pergunta

                $temp=$linha[$linha.Length-4] #adiciona o campo que cont�m o N�MERO da linha na vari�vel temp
                $temp+=$linha[$linha.Length-3]
                $temp+=$linha[$linha.Length-2]
                $indice=achaLinha $temp
                $linha=$dados[$indice]
            }
            
            "f" {exit}

            default {"Entrada inv�lida"}

            }

        }

        else{ #Se a linha em quest�o for uma resposta
            resposta
            $interruptor=1 #quebra o while acima
        }

    }

    
    
    



