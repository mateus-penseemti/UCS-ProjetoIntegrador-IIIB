#!/bin/bash

#testa o argumento -d e envia a mensagem escrita junto com o script para o Discord.
if [ "$1" = "-d" ]
	then
		if [ $# -lt 2 ]
		then
			echo "você não informou nenhum mensagem para enviar para o Discord"
		else
			#testa a quantidade de argumentos, se for informado mais de dois argumentos, envia mensagem de aviso de excesso de argumentos.
			if [ $# -gt 2 ]
				then
					echo "Excesso de argumentos, favor enviar mensagem entre aspas"
					#caso for informado apenas dois argumentos ou a mensagem entre aspas, envia a mensagem para o Discord	
			else
				#envia o argumento na posição dois para o Discord, no caso a mensagem que a pessoa quer enviar
				curl -H "Content-Type: application/json" \
				-X POST \
				-d "{\"username\": \"Servidor\", 
				\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
				\"content\": \"Mensagem do Usuário:\n$2 \" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
				fi
			fi
		else
			#testa o argumento na posição 1 se for digitado -p
			if [ "$1" = "-p" ]
				then
					#joga para variavel usuario uma lista de relacão de UID dos usuários
					usuario=$(cat /etc/passwd | sed 's/:/ /g' | awk '{print $3 '}) 
					#ordena a lista de UID em cada linha
					for i in "echo ${!usuario[*]}"
						do
							#envia a lista de UID para um txt
							echo  "${usuario[*]}" > usuarios.txt
						done
			#lê cada linha do txt
			cat usuarios.txt | while read linha 
				do 
					#testa UID maior que 500
					if [ $linha -gt 500 ]	
						then
							#testa UID menor que 40000
						if [ "$linha" -lt 40000 ]
							then
							#joga para variavel u um cat do passwd printando apenas a mensagem com as posições 1, 3 e 6
							u=$(cat /etc/passwd | grep "x:$linha:" | sed 's/:/ /g' | awk '{print "O Usuário: " $1, "possui a UID: " $3 " - Pasta Home esta localizada no caminho: " $6}')
							#joga para variavel t somente o caminho do diretorio home do usuario
							t=$(cat /etc/passwd | grep "x:$linha:" | sed 's/:/ /g' | awk '{print $6 }')
							#pega o caminho do diretório que esta na variavel t e faz um du para pegar o tamanho da pasta e joga a informação na variavel s
							s=$(du -hs $t | awk '{print "- Tamanho da pasta do usuário: " $1}')
							#envia para o grupo 2 do Discord o conteudo das variaveis u e s
							curl -H "Content-Type: application/json" \
							-X POST \
							-d "{\"username\": \"Servidor\", \"content\": \" $u $s \"}" https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u  
						fi
					fi
				done
			else	
				#testa o argumento na posição 1 se for -m
				if [ "$1" = "-m" ]
					then
						#joga para variavel livre a quantidade de memória ocupada
						livre=$(free -m | grep "Mem:" | awk '{print $4}')
						#testa se a quantidade de memória livre é menor que 512 
							if [ $livre -lt 512 ]
								then
								#envia para o Discord mensagem de ATENÇÃO com a quantidade de memória
								curl -H "Content-Type: application/json" \
								-X POST \
								-d "{\"username\": \"Servidor\", 
								\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
								\"content\": \"ATENÇÃO!! MEMÓRIA BAIXA!!\nMemória livre: $livre MB\" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
							else
								#caso a memória for maior que 512 envia para o Discord um AVISO e a quantidade de memória
								curl -H "Content-Type: application/json" \
								-X POST \
								-d "{\"username\": \"Servidor\", 
								\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
								\"content\": \"AVISO!!\nMemória livre: $livre MB\" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
							fi
				else 
					#caso for informado argumentos diferentes ou faltando, informa para o usuario os arqumentos válidos
					echo "OPÇÃO DE PARÂMETRO INVÁLIDA!"
					echo "Opções de parâmetros disponíveis:" 
					echo "-d para enviar uma mensagem para o Grupo 2 do Discord"
					echo "-p para enviar relação de usuários com UID maior que 500 para o Grupo 2 do Discord"
					echo "-m para consultar estado da memória e enviar aviso para o Grupo 2 do Discord"
				fi
			fi
	fi



