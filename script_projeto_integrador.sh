#!/bin/bash

#TESTE DE PING

#Testa o argumento -ping e executa o camando para testar disponibilidade
if [ "$1" = "-ping" ]
	then
		#Se o parâmetro for menor que 2 informa que falta a palavra para pesquisar
		if [ $# -lt 2 ]
			then
			echo "Você não informou nenhum IP para teste"
	
		else
		#Se os paâmetros forem maiores que 2 avisa que precisa informar apenas um IP
			if [ $# -gt 2 ]
				then
				echo "Excesso de argumentos, favor informar apenas um IP"
			else

			#Se os parâmetros estivem corretos realiza o teste de PING
			echo "Testando IP $2 Aguarde! "

			#Joga na várivel ip o resultado do ping e pega apenas na linha da estatística a quantidade de pacotes retornados
			ip=$(ping -c 4 $2 | grep "packets" | awk '{print $4 '})
			echo "******"
	
				#Testa o resultado da estatistica do ping, pega apenas o valor dos pacotes recebido e testa se for maior que 2 informa ping OK
				#Caso o valor de pacotes recebidos for menor que 2 informa inacessível
				if [ "$ip" -gt 2 ]
					then
					echo "Teste com o IP $2 enviado para o Discord"

					curl -H "Content-Type: application/json" \-X POST \
					-d "{\"username\": \"Servidor\", 
					\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
					\"content\": \"Teste com o IP $2 OK \" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
			
					else
					echo "Teste com o IP $2 enviado para o Discord"

					curl -H "Content-Type: application/json" \-X POST \
					-d "{\"username\": \"Servidor\", 
					\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
					\"content\": \"O IP $2 está inacessível \" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
				fi
			fi
		fi
else

#DEFINIÇÃO DO URBAN DICITIONARY

#Se o parametro no script por -u executa definição da palavra no Urban Dictionary
if [ "$1" = "-u" ]
	then
		#Se o parâmetro for menor que 2 informa que falta a palavra para pesquisar
		if [ $# -lt 2 ]
			then
			echo "Você não informou nenhuma palavra/frase para pesquisar no Urban Dictionary"
		else
		#Se for maior que 2 informa que precisa colocar somente uma palavra ou entre aspas
			if [ $# -gt 2 ]
				then
				echo "Excesso de argumentos, favor pesquisar apenas uma palavra ou se for uma frase colocar entre aspas"
			else
	
			echo "Definição da palavra/frase $2 do Urban Dictionary enviada para o Discord"

			#Joga na variavel Urban a definicição do Urban Dicitionary da palavra digitada no parametro numero 2 no script
			#utilizado comando tr para deletar as pontuações que ocorrem erro para enviar no Discord
			#Utilizado vários sed para substituir expressão (r n) por ENTER 
			urban=$(curl -s https://api.urbandictionary.com/v0/define?term=$2 \ | jq '.list[0].definition' | tr [:punct:] ' ' | sed 's/r n/\\n/g')
	
			#Envia para o Discord o resultado que o Urban Dictionary retornou	
			curl -H "Content-Type: application/json" \-X POST \
			-d "{\"username\": \"Servidor\", 
			\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
			\"content\": \"Definição da palavra/frase $2 no Urban Dictionaray:\n$urban \" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
			
			fi
		fi	
	else

#MENSAGEM PARA O DISCORD

#testa o argumento -d e envia a mensagem escrita junto com o script para o Discord.
if [ "$1" = "-d" ]
	then
		if [ $# -lt 2 ]
			then
			echo "você não informou nenhuma palavra/frase para enviar para o Discord"
			else
			#testa a quantidade de argumentos, se for informado mais de dois argumentos, envia mensagem de aviso de excesso de argumentos.
				if [ $# -gt 2 ]
					then
					echo "Excesso de argumentos, favor enviar a palavra/frase entre aspas"
					#caso for informado apenas dois argumentos ou a mensagem entre aspas, envia a mensagem para o Discord	
				else

				echo "mensagen enviada para o Discord com sucesso"
				#envia o argumento na posição dois para o Discord, no caso a mensagem que a pessoa quer enviar
				curl -H "Content-Type: application/json" \
				-X POST \
				-d "{\"username\": \"Servidor\", 
				\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
				\"content\": \"Mensagem do Usuário:\n$2 \" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
				fi
		fi		
	else

#VERIFICA USUARIO COM UID MAIOR QUE 500

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
			echo "Usuários com UID maior que 500 enviados para o Discord, com informação da pasta Home e espaço utilizado"	
		else

#TESTA MEMÓRIA MENOR QUE 512MB

		#testa o argumento na posição 1 se for -m
		if [ "$1" = "-m" ]
			then
			#joga para variavel livre a quantidade de memória ocupada
			livre=$(free -m | grep "Mem:" | awk '{print $4}')
			#testa se a quantidade de memória livre é menor que 512 
				if [ $livre -lt 512 ]
					then

					echo "Status da memória enviada para o Discord"
					#envia para o Discord mensagem de ATENÇÃO com a quantidade de memória
					curl -H "Content-Type: application/json" \
					-X POST \
					-d "{\"username\": \"Servidor\", 
					\"avatar_url\": \"https://image.flaticon.com/icons/png/512/22/22990.png\",
					\"content\": \"ATENÇÃO!! MEMÓRIA BAIXA!!\nMemória livre: $livre MB\" }"  https://discordapp.com/api/webhooks/717812559771598898/WNV1JFok9GoAeou3KlBzowIWhV7EDUvU8ZiKwimFzegz-jIF9dvY2bgtfNpShle0M83u
					else
					
					echo "Status da memória enviada para o Discord"
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
			echo "-u para pesquisar uma determinada palavra/frase no Urban Dictionary e enviar para o Discord"
		        echo "-ping para teste de PING um IP e enviar o resultado para o Discord" 	
		fi
	fi
fi
fi
fi

