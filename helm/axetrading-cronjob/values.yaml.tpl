# Default values for axetrading-cronjob.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: ""
  pullPolicy: ${imagePullPolicy}
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ${fullNameOverride}

serviceAccount:
  # Specifies whether a service account should be created
  create: ${createServiceAccount}
  # Automatically mount a ServiceAccount's API credentials?
  automount: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}
podLabels: {}

podSecurityContext: {}
  # fsGroup: 2000

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

service:
  type: ${serviceType}
  port: ${servicePort}

ingress:
  enabled: ${ingressEnabled}
  className: ""
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
    %{~ if ingressEnabled ~}
    - host: ${ingressHost}
      paths:
        - path: ${ingressPath}
          pathType: ${ingressPathType}
    %{~ endif ~}
  tls: []


resources:
   limits:
     memory: ${resources.memory}
   requests:
     cpu: ${resources.cpu}
     memory: ${resources.memory}

secretsStore:
  %{~ if awsSecrets != null ~}
  enabled: true
  provider: aws
  awsSecrets:
    %{~ for secret in awsSecrets ~}
    - ${secret}
    %{~ endfor ~}
  %{~ endif ~}
  %{~ if awsSecrets == null ~}
  enabled: false
  %{~ endif ~}

autoscaling:
  %{~ if autoscaling != null ~}
  enabled: true
  minReplicas: ${autoscaling.min_replicas}
  maxReplicas: ${autoscaling.max_replicas}
  targetCPUUtilizationPercentage: ${autoscaling.target_cpu_utilization}
  targetMemoryUtilizationPercentage: ${autoscaling.target_memory_utilization}
  %{~ endif ~}
  %{~ if autoscaling == null ~}
  enabled: false
  %{~ endif ~}

persistence:
  enabled: true
  accessMode: ReadWriteMany
  storageSize: 2Gi
  storageClass: efs
  storageClassName: ""
  mountPath: ""

storageClass:
  create: false
  name: ""

efsProvisioner:
  efsFileSystemId: ""
  reclaimPolicy: retain

cronJob:
  create: %{ if length(cronJobCommands) > 0 && cronJobSchedule != "" }true%{~ else }false%{~ endif }
  cronJobSchedule: ${cronJobSchedule}
  cronJobImageTag: ${cronJobImageTag}
  Commands:
    %{~ for command in cronJobCommands ~}
    - ${command}
    %{~ endfor ~}
