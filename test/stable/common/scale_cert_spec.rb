# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  describe @@chart.name do
    describe 'scaleCertificate' do
      it 'disabled by default' do
        values = {
          ingress: {
            enabled: true
          }
        }
        chart.value values
        assert_nil(resource('Secret'))
      end
      it 'can be enabled and selected' do
        values = {
            "ixCertificateAuthorities": {},
            "ixCertificates": {
              "1": {
                "CA_type_existing": false,
                "CA_type_intermediate": false,
                "CA_type_internal": false,
                "CSR": "",
                "DN": "/C=US/O=iXsystems/CN=localhost/emailAddress=info@ixsystems.com/ST=Tennessee/L=Maryville/subjectAltName=DNS:localhost",
                "cert_type": "CERTIFICATE",
                "cert_type_CSR": false,
                "cert_type_existing": true,
                "cert_type_internal": false,
                "certificate": "-----BEGIN CERTIFICATE-----\nMIIDqjCCApKgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgDELMAkGA1UEBhMCVVMx\nEjAQBgNVBAoMCWlYc3lzdGVtczESMBAGA1UEAwwJbG9jYWxob3N0MSEwHwYJKoZI\nhvcNAQkBFhJpbmZvQGl4c3lzdGVtcy5jb20xEjAQBgNVBAgMCVRlbm5lc3NlZTES\nMBAGA1UEBwwJTWFyeXZpbGxlMB4XDTIwMDkyNTE0MDUzOFoXDTIyMTIyOTE0MDUz\nOFowgYAxCzAJBgNVBAYTAlVTMRIwEAYDVQQKDAlpWHN5c3RlbXMxEjAQBgNVBAMM\nCWxvY2FsaG9zdDEhMB8GCSqGSIb3DQEJARYSaW5mb0BpeHN5c3RlbXMuY29tMRIw\nEAYDVQQIDAlUZW5uZXNzZWUxEjAQBgNVBAcMCU1hcnl2aWxsZTCCASIwDQYJKoZI\nhvcNAQEBBQADggEPADCCAQoCggEBALpoGliii6X8DeoFdLcR7jjsfJIn3nC8f1pT\nLQ3RURHUOEyhPT3Z6TkhaHeHoj8D6kiXROhyJJq3kw5OeqGZisfpGQhkxjpxkfh9\nfAhlvhuLwCWHaMvSh1TaT+h9+eHfcx3un5CIaH8b1KYRBMH+jmKFpr7jkPNkBXLS\nMA7jKIIa8pD9R6lF4gAsbqJafCbT3R7bqkd9xp3n3j2YhqQzETU2lmu4fra3BPio\nofK47kSkguUC6mtk6VrDf2+QtCKlY0dtbF3e2ZBNWo1aj86sjCtoEmqOCMsPRLc/\nXwQcfEqHY4XfafXwqk0G0UxV2ce18xKoR/pN3MpLBZ65NzPnpn0CAwEAAaMtMCsw\nFAYDVR0RBA0wC4IJbG9jYWxob3N0MBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0GCSqG\nSIb3DQEBCwUAA4IBAQBFW1R037y7wllg/gRk9p2T1stiG8iIXosblmL4Ak1YToTQ\n/0to5GY2ZYW29+rbA4SDTS5eeu2YqZ0A/fF3wey7ggzMS7KyNBOvx5QBJRw3PJGn\n+THfhXvdfkOyeUC6KWRGLgl+/zBFvgh6vFDq3jmv0NI4ehVBTBMCJn7r6577S16T\nwtgKMCooizII0Odu5HIF10gTieFIH3PQYm9JBji9iyemb9Ht3wn7fXQptfGadz/l\nWz/Dv9+a6IOr7JVJMHnqAIvPzpkav4efuVPOX1zbhjg4K5g+nRYfjr5F5upOd0Y3\nznWTUBUyI7CXRkpHtSDXfEqKgnk/8uv7GWw+hyKr\n-----END CERTIFICATE-----\n",
                "certificate_path": "/etc/certificates/freenas_default.crt",
                "chain": false,
                "chain_list": [
                  "-----BEGIN CERTIFICATE-----\nMIIDqjCCApKgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgDELMAkGA1UEBhMCVVMx\nEjAQBgNVBAoMCWlYc3lzdGVtczESMBAGA1UEAwwJbG9jYWxob3N0MSEwHwYJKoZI\nhvcNAQkBFhJpbmZvQGl4c3lzdGVtcy5jb20xEjAQBgNVBAgMCVRlbm5lc3NlZTES\nMBAGA1UEBwwJTWFyeXZpbGxlMB4XDTIwMDkyNTE0MDUzOFoXDTIyMTIyOTE0MDUz\nOFowgYAxCzAJBgNVBAYTAlVTMRIwEAYDVQQKDAlpWHN5c3RlbXMxEjAQBgNVBAMM\nCWxvY2FsaG9zdDEhMB8GCSqGSIb3DQEJARYSaW5mb0BpeHN5c3RlbXMuY29tMRIw\nEAYDVQQIDAlUZW5uZXNzZWUxEjAQBgNVBAcMCU1hcnl2aWxsZTCCASIwDQYJKoZI\nhvcNAQEBBQADggEPADCCAQoCggEBALpoGliii6X8DeoFdLcR7jjsfJIn3nC8f1pT\nLQ3RURHUOEyhPT3Z6TkhaHeHoj8D6kiXROhyJJq3kw5OeqGZisfpGQhkxjpxkfh9\nfAhlvhuLwCWHaMvSh1TaT+h9+eHfcx3un5CIaH8b1KYRBMH+jmKFpr7jkPNkBXLS\nMA7jKIIa8pD9R6lF4gAsbqJafCbT3R7bqkd9xp3n3j2YhqQzETU2lmu4fra3BPio\nofK47kSkguUC6mtk6VrDf2+QtCKlY0dtbF3e2ZBNWo1aj86sjCtoEmqOCMsPRLc/\nXwQcfEqHY4XfafXwqk0G0UxV2ce18xKoR/pN3MpLBZ65NzPnpn0CAwEAAaMtMCsw\nFAYDVR0RBA0wC4IJbG9jYWxob3N0MBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0GCSqG\nSIb3DQEBCwUAA4IBAQBFW1R037y7wllg/gRk9p2T1stiG8iIXosblmL4Ak1YToTQ\n/0to5GY2ZYW29+rbA4SDTS5eeu2YqZ0A/fF3wey7ggzMS7KyNBOvx5QBJRw3PJGn\n+THfhXvdfkOyeUC6KWRGLgl+/zBFvgh6vFDq3jmv0NI4ehVBTBMCJn7r6577S16T\nwtgKMCooizII0Odu5HIF10gTieFIH3PQYm9JBji9iyemb9Ht3wn7fXQptfGadz/l\nWz/Dv9+a6IOr7JVJMHnqAIvPzpkav4efuVPOX1zbhjg4K5g+nRYfjr5F5upOd0Y3\nznWTUBUyI7CXRkpHtSDXfEqKgnk/8uv7GWw+hyKr\n-----END CERTIFICATE-----\n"
                ],
                "city": "Maryville",
                "common": "localhost",
                "country": "US",
                "csr_path": "/etc/certificates/freenas_default.csr",
                "digest_algorithm": "SHA256",
                "email": "info@ixsystems.com",
                "extensions": {
                  "ExtendedKeyUsage": "TLS Web Server Authentication",
                  "SubjectAltName": "DNS:localhost"
                },
                "fingerprint": "9C:5A:1D:1B:E7:9E:0B:89:2B:37:F4:19:83:ED:3C:6B:D8:14:0D:9B",
                "from": "Fri Sep 25 16:05:38 2020",
                "id": 1,
                "internal": "NO",
                "issuer": "external",
                "key_length": 2048,
                "key_type": "RSA",
                "lifetime": 825,
                "name": "freenas_default",
                "organization": "iXsystems",
                "organizational_unit": "",
                "parsed": true,
                "privatekey": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6aBpYooul/A3q\nBXS3Ee447HySJ95wvH9aUy0N0VER1DhMoT092ek5IWh3h6I/A+pIl0TociSat5MO\nTnqhmYrH6RkIZMY6cZH4fXwIZb4bi8Alh2jL0odU2k/offnh33Md7p+QiGh/G9Sm\nEQTB/o5ihaa+45DzZAVy0jAO4yiCGvKQ/UepReIALG6iWnwm090e26pHfcad5949\nmIakMxE1NpZruH62twT4qKHyuO5EpILlAuprZOlaw39vkLQipWNHbWxd3tmQTVqN\nWo/OrIwraBJqjgjLD0S3P18EHHxKh2OF32n18KpNBtFMVdnHtfMSqEf6TdzKSwWe\nuTcz56Z9AgMBAAECggEARwcb4uIs7BZbBu0FSCyg5TfXT6m5bKOmszg2VqmHho+i\n1DAsMcEyyP4d3E3mWLSZNQfOzfOQVxPUCQOGXsUuyHXdgAFGN0bHJDRMara59a0O\njj5GhEO4JXD6OdCmwpZuOt2OF3iiuKxWHuElOvZQMuJSYzI7LULTgKjufv23lbsf\nxMO/v9yi57c5EGgnQ8siLKOy/FQZapn4Z9qKn+lVyk5gfaKP0pDsvV4d7nGYMDD2\nYijfkSyNecApFdtWiLE5zLUlvF6oNj8o66z3YrVNKrCPzhA/5Rkkwwk32SNxvKU3\nVZFSNPeOZ60BicxYcWO+b2aAa0WF+uazJAZ4q52gUQKBgQDu88R+0wm76secYkzE\nQglteLNZKFcvth0kI5xH42Hmk9IXkGimFoDJCIrLAuopyGnfNmqmh2is3QUMUPdR\n/wDLnKc4MCezEidNoD2RBC+bzM1hB9oye/b5sOZUDFXSa0k4XSLu1UEuy1yWhkuS\n6JjY1KQfc4FN0K0Fjqqo7UCTCwKBgQDHtKQh/NvMJ2ok4YW+/QAsus4mEK9eCyUy\nOuyDszQYrGvjkS7STKJVNxGLhWb0XKSIAxMZ66b1MwOt+71h7xNn6pcancfVdK7F\n1Xl5J+76SwbXSgQwTZuoMDxPIvZn7v/2ep5Ni/BcOhMcPIcobWb/OmXrFN1brBvo\nlFNQyWWhlwKBgFDAyPMjVvLO0U6kWdUpjA4W8GV9IJnbLdX8wt/4lClcY2/bOcKH\ncFaAMIeTIJemR0FMHpbQxCtHNmGHK03mo9orwsdWXtRBmk69jJDpnT1F5VKZWMAe\n7MRNaEmXMZm+8CvALgIQx8qMp2mnUPsA6Ea+9gg6/MPTdeWe5UXZiC0pAoGAGtSt\nPJfBXBNrklruYjORo3DRo5GYThVHQRFjl2orNKltsVxfIwgCw1ortEgPBgOwY0mu\ndkwP2V+qPeTVk+PQAqUk+gF6yLXtiUzeDiYMWHpeB+y81VSH9jfM0oELA/m7T/03\naYnEmE+BI8kKC6dvMBlDeisKdneQJFZRP0hfrC8CgYEAgYIyCGwcydKpe2Nkj0Fz\nKTtCMC/k4DvJfd5Kb9AbmrPUfKgA9Xj4GT6yPG6uBMi8r5etvLCKJ2x2NtN024a8\nQJLATYPrSsaZkE+9zM0j5nYAgbKpxBhlDzDAzn//3ByVzfgJ25S80XhTI2lfbLH/\nU07ssxdZaQCo+WuD82OvNcg=\n-----END PRIVATE KEY-----\n",
                "privatekey_path": "/etc/certificates/freenas_default.key",
                "revoked": false,
                "revoked_date": "",
                "root_path": "/etc/certificates",
                "san": [
                  "DNS:localhost"
                ],
                "serial": 1,
                "signedby": "",
                "state": "Tennessee",
                "subject_name_hash": 3193428416,
                "type": 8,
                "until": "Thu Dec 29 15:05:38 2022"
              }
            },
          ingress: {
            enabled: true,
            scaleCert: 1
          }
        }
        chart.value values
        refute_nil(resource('Secret'))
        secret = chart.resources(kind: "Secret").first
        assert_equal("common-test-scalecert", secret["metadata"]["name"])
        refute_nil(secret["data"]["tls.crt"])
        refute_nil(secret["data"]["tls.key"])
      end

      it 'secret can be used for TLS ingress' do
        values = {
            "ixCertificateAuthorities": {},
            "ixCertificates": {
              "1": {
                "CA_type_existing": false,
                "CA_type_intermediate": false,
                "CA_type_internal": false,
                "CSR": "",
                "DN": "/C=US/O=iXsystems/CN=localhost/emailAddress=info@ixsystems.com/ST=Tennessee/L=Maryville/subjectAltName=DNS:localhost",
                "cert_type": "CERTIFICATE",
                "cert_type_CSR": false,
                "cert_type_existing": true,
                "cert_type_internal": false,
                "certificate": "-----BEGIN CERTIFICATE-----\nMIIDqjCCApKgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgDELMAkGA1UEBhMCVVMx\nEjAQBgNVBAoMCWlYc3lzdGVtczESMBAGA1UEAwwJbG9jYWxob3N0MSEwHwYJKoZI\nhvcNAQkBFhJpbmZvQGl4c3lzdGVtcy5jb20xEjAQBgNVBAgMCVRlbm5lc3NlZTES\nMBAGA1UEBwwJTWFyeXZpbGxlMB4XDTIwMDkyNTE0MDUzOFoXDTIyMTIyOTE0MDUz\nOFowgYAxCzAJBgNVBAYTAlVTMRIwEAYDVQQKDAlpWHN5c3RlbXMxEjAQBgNVBAMM\nCWxvY2FsaG9zdDEhMB8GCSqGSIb3DQEJARYSaW5mb0BpeHN5c3RlbXMuY29tMRIw\nEAYDVQQIDAlUZW5uZXNzZWUxEjAQBgNVBAcMCU1hcnl2aWxsZTCCASIwDQYJKoZI\nhvcNAQEBBQADggEPADCCAQoCggEBALpoGliii6X8DeoFdLcR7jjsfJIn3nC8f1pT\nLQ3RURHUOEyhPT3Z6TkhaHeHoj8D6kiXROhyJJq3kw5OeqGZisfpGQhkxjpxkfh9\nfAhlvhuLwCWHaMvSh1TaT+h9+eHfcx3un5CIaH8b1KYRBMH+jmKFpr7jkPNkBXLS\nMA7jKIIa8pD9R6lF4gAsbqJafCbT3R7bqkd9xp3n3j2YhqQzETU2lmu4fra3BPio\nofK47kSkguUC6mtk6VrDf2+QtCKlY0dtbF3e2ZBNWo1aj86sjCtoEmqOCMsPRLc/\nXwQcfEqHY4XfafXwqk0G0UxV2ce18xKoR/pN3MpLBZ65NzPnpn0CAwEAAaMtMCsw\nFAYDVR0RBA0wC4IJbG9jYWxob3N0MBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0GCSqG\nSIb3DQEBCwUAA4IBAQBFW1R037y7wllg/gRk9p2T1stiG8iIXosblmL4Ak1YToTQ\n/0to5GY2ZYW29+rbA4SDTS5eeu2YqZ0A/fF3wey7ggzMS7KyNBOvx5QBJRw3PJGn\n+THfhXvdfkOyeUC6KWRGLgl+/zBFvgh6vFDq3jmv0NI4ehVBTBMCJn7r6577S16T\nwtgKMCooizII0Odu5HIF10gTieFIH3PQYm9JBji9iyemb9Ht3wn7fXQptfGadz/l\nWz/Dv9+a6IOr7JVJMHnqAIvPzpkav4efuVPOX1zbhjg4K5g+nRYfjr5F5upOd0Y3\nznWTUBUyI7CXRkpHtSDXfEqKgnk/8uv7GWw+hyKr\n-----END CERTIFICATE-----\n",
                "certificate_path": "/etc/certificates/freenas_default.crt",
                "chain": false,
                "chain_list": [
                  "-----BEGIN CERTIFICATE-----\nMIIDqjCCApKgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgDELMAkGA1UEBhMCVVMx\nEjAQBgNVBAoMCWlYc3lzdGVtczESMBAGA1UEAwwJbG9jYWxob3N0MSEwHwYJKoZI\nhvcNAQkBFhJpbmZvQGl4c3lzdGVtcy5jb20xEjAQBgNVBAgMCVRlbm5lc3NlZTES\nMBAGA1UEBwwJTWFyeXZpbGxlMB4XDTIwMDkyNTE0MDUzOFoXDTIyMTIyOTE0MDUz\nOFowgYAxCzAJBgNVBAYTAlVTMRIwEAYDVQQKDAlpWHN5c3RlbXMxEjAQBgNVBAMM\nCWxvY2FsaG9zdDEhMB8GCSqGSIb3DQEJARYSaW5mb0BpeHN5c3RlbXMuY29tMRIw\nEAYDVQQIDAlUZW5uZXNzZWUxEjAQBgNVBAcMCU1hcnl2aWxsZTCCASIwDQYJKoZI\nhvcNAQEBBQADggEPADCCAQoCggEBALpoGliii6X8DeoFdLcR7jjsfJIn3nC8f1pT\nLQ3RURHUOEyhPT3Z6TkhaHeHoj8D6kiXROhyJJq3kw5OeqGZisfpGQhkxjpxkfh9\nfAhlvhuLwCWHaMvSh1TaT+h9+eHfcx3un5CIaH8b1KYRBMH+jmKFpr7jkPNkBXLS\nMA7jKIIa8pD9R6lF4gAsbqJafCbT3R7bqkd9xp3n3j2YhqQzETU2lmu4fra3BPio\nofK47kSkguUC6mtk6VrDf2+QtCKlY0dtbF3e2ZBNWo1aj86sjCtoEmqOCMsPRLc/\nXwQcfEqHY4XfafXwqk0G0UxV2ce18xKoR/pN3MpLBZ65NzPnpn0CAwEAAaMtMCsw\nFAYDVR0RBA0wC4IJbG9jYWxob3N0MBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0GCSqG\nSIb3DQEBCwUAA4IBAQBFW1R037y7wllg/gRk9p2T1stiG8iIXosblmL4Ak1YToTQ\n/0to5GY2ZYW29+rbA4SDTS5eeu2YqZ0A/fF3wey7ggzMS7KyNBOvx5QBJRw3PJGn\n+THfhXvdfkOyeUC6KWRGLgl+/zBFvgh6vFDq3jmv0NI4ehVBTBMCJn7r6577S16T\nwtgKMCooizII0Odu5HIF10gTieFIH3PQYm9JBji9iyemb9Ht3wn7fXQptfGadz/l\nWz/Dv9+a6IOr7JVJMHnqAIvPzpkav4efuVPOX1zbhjg4K5g+nRYfjr5F5upOd0Y3\nznWTUBUyI7CXRkpHtSDXfEqKgnk/8uv7GWw+hyKr\n-----END CERTIFICATE-----\n"
                ],
                "city": "Maryville",
                "common": "localhost",
                "country": "US",
                "csr_path": "/etc/certificates/freenas_default.csr",
                "digest_algorithm": "SHA256",
                "email": "info@ixsystems.com",
                "extensions": {
                  "ExtendedKeyUsage": "TLS Web Server Authentication",
                  "SubjectAltName": "DNS:localhost"
                },
                "fingerprint": "9C:5A:1D:1B:E7:9E:0B:89:2B:37:F4:19:83:ED:3C:6B:D8:14:0D:9B",
                "from": "Fri Sep 25 16:05:38 2020",
                "id": 1,
                "internal": "NO",
                "issuer": "external",
                "key_length": 2048,
                "key_type": "RSA",
                "lifetime": 825,
                "name": "freenas_default",
                "organization": "iXsystems",
                "organizational_unit": "",
                "parsed": true,
                "privatekey": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6aBpYooul/A3q\nBXS3Ee447HySJ95wvH9aUy0N0VER1DhMoT092ek5IWh3h6I/A+pIl0TociSat5MO\nTnqhmYrH6RkIZMY6cZH4fXwIZb4bi8Alh2jL0odU2k/offnh33Md7p+QiGh/G9Sm\nEQTB/o5ihaa+45DzZAVy0jAO4yiCGvKQ/UepReIALG6iWnwm090e26pHfcad5949\nmIakMxE1NpZruH62twT4qKHyuO5EpILlAuprZOlaw39vkLQipWNHbWxd3tmQTVqN\nWo/OrIwraBJqjgjLD0S3P18EHHxKh2OF32n18KpNBtFMVdnHtfMSqEf6TdzKSwWe\nuTcz56Z9AgMBAAECggEARwcb4uIs7BZbBu0FSCyg5TfXT6m5bKOmszg2VqmHho+i\n1DAsMcEyyP4d3E3mWLSZNQfOzfOQVxPUCQOGXsUuyHXdgAFGN0bHJDRMara59a0O\njj5GhEO4JXD6OdCmwpZuOt2OF3iiuKxWHuElOvZQMuJSYzI7LULTgKjufv23lbsf\nxMO/v9yi57c5EGgnQ8siLKOy/FQZapn4Z9qKn+lVyk5gfaKP0pDsvV4d7nGYMDD2\nYijfkSyNecApFdtWiLE5zLUlvF6oNj8o66z3YrVNKrCPzhA/5Rkkwwk32SNxvKU3\nVZFSNPeOZ60BicxYcWO+b2aAa0WF+uazJAZ4q52gUQKBgQDu88R+0wm76secYkzE\nQglteLNZKFcvth0kI5xH42Hmk9IXkGimFoDJCIrLAuopyGnfNmqmh2is3QUMUPdR\n/wDLnKc4MCezEidNoD2RBC+bzM1hB9oye/b5sOZUDFXSa0k4XSLu1UEuy1yWhkuS\n6JjY1KQfc4FN0K0Fjqqo7UCTCwKBgQDHtKQh/NvMJ2ok4YW+/QAsus4mEK9eCyUy\nOuyDszQYrGvjkS7STKJVNxGLhWb0XKSIAxMZ66b1MwOt+71h7xNn6pcancfVdK7F\n1Xl5J+76SwbXSgQwTZuoMDxPIvZn7v/2ep5Ni/BcOhMcPIcobWb/OmXrFN1brBvo\nlFNQyWWhlwKBgFDAyPMjVvLO0U6kWdUpjA4W8GV9IJnbLdX8wt/4lClcY2/bOcKH\ncFaAMIeTIJemR0FMHpbQxCtHNmGHK03mo9orwsdWXtRBmk69jJDpnT1F5VKZWMAe\n7MRNaEmXMZm+8CvALgIQx8qMp2mnUPsA6Ea+9gg6/MPTdeWe5UXZiC0pAoGAGtSt\nPJfBXBNrklruYjORo3DRo5GYThVHQRFjl2orNKltsVxfIwgCw1ortEgPBgOwY0mu\ndkwP2V+qPeTVk+PQAqUk+gF6yLXtiUzeDiYMWHpeB+y81VSH9jfM0oELA/m7T/03\naYnEmE+BI8kKC6dvMBlDeisKdneQJFZRP0hfrC8CgYEAgYIyCGwcydKpe2Nkj0Fz\nKTtCMC/k4DvJfd5Kb9AbmrPUfKgA9Xj4GT6yPG6uBMi8r5etvLCKJ2x2NtN024a8\nQJLATYPrSsaZkE+9zM0j5nYAgbKpxBhlDzDAzn//3ByVzfgJ25S80XhTI2lfbLH/\nU07ssxdZaQCo+WuD82OvNcg=\n-----END PRIVATE KEY-----\n",
                "privatekey_path": "/etc/certificates/freenas_default.key",
                "revoked": false,
                "revoked_date": "",
                "root_path": "/etc/certificates",
                "san": [
                  "DNS:localhost"
                ],
                "serial": 1,
                "signedby": "",
                "state": "Tennessee",
                "subject_name_hash": 3193428416,
                "type": 8,
                "until": "Thu Dec 29 15:05:38 2022"
              }
            },
          ingress: {
            enabled: true,
            scaleCert: 1,
            tls: [
              {
                hosts: [ 'hostname' ],
                scaleCert: true
              }
            ]
          }
        }
        chart.value values
        refute_nil(resource('Secret'))
        secret = chart.resources(kind: "Secret").first
        assert_equal("common-test-scalecert", secret["metadata"]["name"])
        refute_nil(secret["data"]["tls.crt"])
        refute_nil(secret["data"]["tls.key"])

        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal("common-test-scalecert", ingress["spec"]["tls"][0]["secretName"])
      end
    end
  end
end
