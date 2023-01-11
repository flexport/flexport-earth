import { defineConfig } from 'cypress'

const gmail = require("gmail-tester");

type GmailApiCredentials = {
  clientId:     string,
  clientSecret: string,
  refreshToken: string
};

async function GmailCheck(
  {
    gmailApiCredentials,
    from,
    to,
    subject,
    after
  }: {
    gmailApiCredentials:  GmailApiCredentials,
    from:                 string,
    to:                   string,
    subject:              string,
    after:                number
  }) {
    const email = await gmail.check_inbox(
      { installed:  {
                      client_id:                    gmailApiCredentials.clientId,
                      auth_uri:                     "https://accounts.google.com/o/oauth2/auth",
                      token_uri:                    "https://oauth2.googleapis.com/token",
                      auth_provider_x509_cert_url:  "https://www.googleapis.com/oauth2/v1/certs",
                      client_secret:                gmailApiCredentials.clientSecret,
                      redirect_uris:                [
                                                      "http://localhost"
                                                    ]
                    }
      },
      {
        refresh_token:  gmailApiCredentials.refreshToken,
        scope:          "https://www.googleapis.com/auth/gmail.readonly",
        token_type:     "Bearer",
        expiry_date:    1673294576252
      },
      {
        subject,
        from,
        to,
        after,
        wait_time_sec:      5,   // Poll interval (in seconds)
        max_wait_time_sec:  500  // Maximum poll interval (in seconds). If reached, return null, indicating the completion of the task().
      }
    );

    return email;
}

export default defineConfig({
  viewportWidth:      1920,
  viewportHeight:     1200,
  videosFolder:       "results/videos",
  screenshotsFolder:  "results/screenshots",
  retries:            {
                        "runMode": 3
                      },
  e2e:                {
                        setupNodeEvents(on, config) {
                          on("task", {
                            "gmail:check": async args => await GmailCheck(args)
                          });
                        },
                        specPattern: "**/*.spec.ts"
                      },
  chromeWebSecurity:  false
});
