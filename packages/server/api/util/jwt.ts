import jwt from "express-jwt"
import jwksRsa from "jwks-rsa"

// Authentication middleware. When used, the
// Access Token must exist and be verified against
// the Auth0 JSON Web Key Set
export default jwt({
  // Dynamically provide a signing key
  // based on the kid in the header and
  // the signing keys provided by the JWKS endpoint.
  secret: jwksRsa.expressJwtSecret({
    jwksUri: "https://example.com/.well-known/jwks.json",
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
  }),

  // Validate the audience and the issuer.
  audience: "https://example.com/",
  issuer: "https://example.com/",
  algorithms: ["RS256"],
})
