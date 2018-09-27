# Sample native app PISP Implementation from Yapily

A ready to use implementation of a TPP using [Yapily SDK](https://www.forgerock.com/about-us/events/2018/09/open-banking-hackathon) to connect on financial institutions
during [Forgerock Open Banking Hackathlon](https://www.forgerock.com/about-us/events/2018/09/open-banking-hackathon).
Developed on [flutter](https://flutter.io/) native app framework.

![moneyme](moneyme.png)

## Getting Started

1. Register a developer account on [https://dashboard.yapily.com](https://dashboard.yapily.com)
2. Create an application:
    * Configure the callback Url to be the same as in the [yapily-config](yapily-assets/yapily-config.json) file.
    * Select the financial institutions you would like your application to connect to.
    * See this [wiki](https://github.com/yapily/developer-resources/wiki/Institution-Configurations) guide for details on obtaining credentials for each of the financial institutions. Alternatively, if you are connecting to a sandbox institution, you can use the preconfigured sandbox credentials.
3. Your application will be issued with a unique application key and application secret to use when connecting to the Yapily API.
4. Replace your application key and secret in [yapily-config](yapily-assets/yapily-config.json) file

Now you are ready to build and deploy your application, Enjoy!

## Further information

For more information on how to get connected, visit the
[Yapily developer resources](https://github.com/yapily/developer-resources) repo.

###### [Website](https://yapily.com) | [Legal](https://yapily.com/legal-policies) | [Contact Us](mailto:info@yapily.com)

#### Disclaimer

The ***MONEYME*** name was created by [Yapily](htpps://wwww.yapily.com) and should not be used outside the scope of testing this application.

