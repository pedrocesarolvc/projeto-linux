#!/bin/bash
#Arquivo de pedidos
DB="pedidos.txt"

#Garante que o arquivo existe
touch "$DB"

registrar_produto() { #seleciona o produto
    while true; do
        echo "Selecione um Produto: "
        echo "1. Carregador"
        echo "2. Cabo"
        echo "3. Capinha"
        echo "4. Película"
        echo "5. Fone"
        read -p "Escolha um item: " item

        case "$item" in
            1)
                produto="Carregador"
                break
                ;;
            2)
                produto="Cabo"
                break
                ;;
            3)
                produto="Capinha"
                break
                ;;
            4)
                produto="Película"
                break
                ;;
            5)
                produto="Fone"
                break
                ;;
            *)
                echo "Opção inválida!"
                ;;
        esac
    done
}

registrar_pagamento() { #registra o produto
    registrar_produto
    read -p "Número do pedido: " pedido
    data=$(date)
    echo "$pedido|$produto|PAGO|$data|AGUARDANDO_ENTREGA" >> "$DB"
    echo "Nota fiscal emitida para o pedido $pedido."
    echo "Produto: $produto"
    echo "Status: PAGO"
    echo "Data: $data"
}

iniciar_entrega() { #inicia a entrega do produto com base no número do pedido 
    read -p "Número do pedido: " pedido

    if grep -q "^$pedido|" "$DB"; then
        produto=$(grep "^$pedido|" "$DB" | cut -d'|' -f2)
        sed -i "s/^$pedido|$produto|PAGO|.*|AGUARDANDO_ENTREGA/$pedido|$produto|PAGO|$(date)|EM_ENTREGA/" "$DB"
        read -p "Tempo de entrega estimado (em segundos): " tempo

        echo "Pedido $pedido saiu para entrega!"
        while (( tempo > 0 )); do
            echo "Tempo restante: $tempo segundos"
            sleep 1
            ((tempo--))
        done

        sed -i "s/^$pedido|$produto|PAGO|.*|EM_ENTREGA/$pedido|$produto|PAGO|$(date)|ENTREGUE/" "$DB"
        echo "Pedido $pedido ENTREGUE!"
    else
        echo "Pedido não encontrado!"
    fi
}

ver_status() { #Lista todos os pedidos
    echo "=== STATUS DOS PEDIDOS ==="

    if [ -s "$DB" ]; then
        column -t -s '|' "$DB"
    else
        echo "Nenhum pedido registrado."
    fi
}

deletar_produto() {
    ver_status #Lista os pedidos
    read -p "Digite o número do pedido que deseja cancelar: " pedido
    
    if grep -q "^$pedido|" "$DB"; then

        grep -v "^$pediddo|" "$DB" > "$DB.temp"
        mv "$DB.temp" "$DB"
        echo "Pedido cancelado com sucesso!"
    else 
        echo "Pedido não encontrado, selecione um número válido!"
    fi
}

while true; do
    echo ""
    echo "==== MENU DE OPÇÕES ===="
    echo "1. Registrar produto"
    echo "2. Registrar pagamento"
    echo "3. Iniciar entrega"
    echo "4. Ver status de pedidos"
    echo "5. Deletar produto"
    echo "6. Sair"
    read -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)
            registrar_produto
            echo "Produto registrado: $produto"
            ;;
        2)
            registrar_pagamento
            ;;
        3)
            iniciar_entrega
            ;;
        4)
            ver_status
            ;;
        5)
            deletar_produto
            ;;
        6) 
            Sair
            break
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
done