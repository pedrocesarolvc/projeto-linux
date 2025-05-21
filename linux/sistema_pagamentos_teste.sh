#!/bin/bash
# Arquivo de pedidos
DB="pedidos.txt"

# Garante que o arquivo existe
touch "$DB"
# Fazer uma função para pedir o produtoe só depois registrar o status do pagamento

registrar_produto() {
    echo "Selecione um Produto: "
    echo "1. Carregador"
    echo "2. Cabo"
    echo "3. Capinha"
    echo "4. Película"
    echo "5. Fone"
    read -p "Escolha um item: " item
}
while true do
    case "$item" in
            1)
                echo -p "Carregador Escolhido" produto
                break
                ;;
            2)
                echo -p "Cabo Escolhido" produto
                break
                ;;
            3)
                echo -p "Capinha Escolhido" produto
                break
                ;;
            4)
                echo -p "Película Escolhido" produto
                break
                ;;
            5)
                echo -p "Fone Escolhido" produto
                break
                ;;
            *)
                echo "Opção inválida!"
                ;;
        esac
done
registrar_pagamento() {
    read -p "Número do pedido: " pedido
    data=$(date)
    echo "$pedido|PAGO|$data|AGUARDANDO_ENTREGA" >> "$DB"
    echo "Nota fiscal emitida para o pedido $pedido."
    echo "Status: PAGO"
    echo "Data: $data"
}

iniciar_entrega() {
    read -p "Número do pedido: " pedido

    if grep -q "^$pedido|" "$DB"; then
        sed -i "s/^$pedido|PAGO|.*|AGUARDANDO_ENTREGA/$pedido|PAGO|$(date)|EM_ENTREGA/" "$DB"
        read -p "Tempo de entrega estimado (em segundos): " tempo

        echo "Pedido $pedido saiu para entrega!"
        while (( "$tempo" > 0 )) ; do
            echo "Tempo restante: $tempo segundos"
            sleep 1
            ((tempo--))
        done

        sed -i "s/^$pedido|PAGO|.*|EM_ENTREGA/$pedido|PAGO|$(date)|ENTREGUE/" "$DB"
        echo "Pedido $pedido ENTREGUE!"
    else
        echo "Pedido não encontrado!"
    fi
}

ver_status() {
    echo "=== STATUS DOS PEDIDOS ==="

    if [ -s "$DB" ]; then
        column -t -s '|' "$DB"
    else
        echo "Nenhum pedido registrado."
    fi
}

while true; do
    echo ""
    echo "==== MENU DE OPÇÕES ===="
    echo "1. Registrar produto"
    echo "2. Registrar pagamento"
    echo "3. Iniciar entrega"
    echo "4. Ver status de pedidos"
    echo "5. Sair"
    read -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)
            registrar_produto
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
            echo "Saindo..."
            break
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
done