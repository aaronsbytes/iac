# Create oidc/jwks directories
mkdir -p "{{ docker.data_dir }}/authelia/secrets/oidc/jwks"

# Generate private rsa key
if [ ! -f "{{ docker.data_dir }}/authelia/secrets/oidc/jwks/rsa_private.pem" ]; then
    openssl genrsa -out "{{ docker.data_dir }}/authelia/secrets/oidc/jwks/rsa_private.pem" 2048
fi

# Generate hmac secret
if [ ! -f "{{ docker.data_dir }}/authelia/secrets/HMAC_SECRET" ]; then
    openssl rand -hex 32 | openssl dgst -sha256 -out "{{ docker.data_dir }}/authelia/secrets/HMAC_SECRET"
fi

# Generate jwt secret
if [ ! -f "{{ docker.data_dir }}/authelia/secrets/JWT_SECRET" ]; then
    openssl rand -hex 32 | openssl dgst -sha256 -out "{{ docker.data_dir }}/authelia/secrets/JWT_SECRET"
fi

# Generate session secret
if [ ! -f "{{ docker.data_dir }}/authelia/secrets/SESSION_SECRET" ]; then
    openssl rand -hex 32 | openssl dgst -sha256 -out "{{ docker.data_dir }}/authelia/secrets/SESSION_SECRET"
fi

# Generate storage encryption key
if [ ! -f "{{ docker.data_dir }}/authelia/secrets/STORAGE_ENCRYPTION_KEY" ]; then
    openssl rand -hex 32 | openssl dgst -sha256 -out "{{ docker.data_dir }}/authelia/secrets/STORAGE_ENCRYPTION_KEY"
fi
