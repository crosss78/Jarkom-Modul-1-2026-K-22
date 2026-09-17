#!/bin/bash

echo "========================================"
echo "       RINGKASAN STATUS JARINGAN"
echo "========================================"

echo
echo "[ INTERFACE ]"
ip -br a

echo
echo "[ TABEL NAT ]"
iptables -t nat -L -v -n

echo
echo "========================================"
echo "       CEK SELESAI"
echo "========================================"