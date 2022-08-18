# Notes

## Schedule all master nodes as not available (we are not going to do that):
function configInfraNodes() {

  for node_index in 0 1 2
  do
    ${OC} label nodes ${CLUSTER_NAME}-master-${node_index}.${SUB_DOMAIN}.${LAB_DOMAIN} node-role.kubernetes.io/infra=""
  done
  ${OC} patch scheduler cluster --patch '{"spec":{"mastersSchedulable":false}}' --type=merge
  ${OC} patch -n openshift-ingress-operator ingresscontroller default --patch '{"spec":{"nodePlacement":{"nodeSelector":{"matchLabels":{"node-role.kubernetes.io/infra":""}},"tolerations":[{"key":"node.kubernetes.io/unschedulable","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","effect":"NoSchedule"}]}}}' --type=merge
  for node_index in $(${OC} get pods -n openshift-ingress-canary | grep -v NAME | cut -d" " -f1)
  do
    ${OC} delete pod ${node_index} -n openshift-ingress-canary
  done

  ${OC} patch configs.imageregistry.operator.openshift.io cluster --patch '{"spec":{"nodeSelector":{"node-role.kubernetes.io/infra":""},"tolerations":[{"key":"node.kubernetes.io/unschedulable","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","effect":"NoSchedule"}]}}' --type=merge

cat << EOF | ${OC} apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    prometheusOperator:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    prometheusK8s:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    alertmanagerMain:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    kubeStateMetrics:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    grafana:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    telemeterClient:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    k8sPrometheusAdapter:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    openshiftStateMetrics:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
    thanosQuerier:
      nodeSelector:
        node-role.kubernetes.io/infra: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        value: ""
        effect: "NoSchedule"
EOF
}
