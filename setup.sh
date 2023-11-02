#!/bin/bash

slpxt_timer  () { echo "Exiting... " && sleep 10 && exit; }

echo "Running startup script"
echo 'checking $KUBECONFIG for kubectl'
[[ -f ${KUBECONFIG} ]] && echo "KUBECONFIG is set." || $(echo "KUBECONFIG is not set." && slpxt_timer)

echo 'Testing kubectl'
/usr/local/bin/kubectl get nodes >/dev/null ||  $(echo "kubectl failed to connect." && slpxt_timer)

echo 'checking $ENCRYPTION_KEY for 7zip encryption'
[[ ! -z ${ENCRYPTION_KEY} ]] && echo "ENCRYPTION_KEY is set." || $(echo "SECRET is not set."; slpxt_timer)

echo 'checking $BACKUP_DIR for availability'
[[ -d ${BACKUP_DIR} ]] && echo "BACKUP_DIR is set." || $(echo "BACKUP_DIR is not set."; slpxt_timer)

DATE=$(date +%Y-%m-%d-%H-%M)

/usr/local/bin/kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > $BACKUP_DIR/sealed-secrets.${DATE}.key

/usr/bin/7z a -p${ENCRYPTION_KEY} -mhe=on ${BACKUP_DIR}/sealed-secrets.${DATE}.7z ${BACKUP_DIR}/sealed-secrets.${DATE}.key
sleep 1
[[ -f ${BACKUP_DIR}/sealed-secrets.${DATE}.7z ]] && rm -rvf ${BACKUP_DIR}/sealed-secrets.${DATE}.key
