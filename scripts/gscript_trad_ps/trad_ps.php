
<?php
require_once __DIR__ . '/vendor/autoload.php';


define('APPLICATION_NAME', 'Traductions Pharmasimple');
define('CREDENTIALS_PATH', '~/.credentials/script-php-trad-ps.json');
define('CLIENT_SECRET_PATH', __DIR__ . '/client_secret.json');
define('GDRIVE_PATH', '~/Google Drive/');
define('FILENAME', 'strings.xml');
define('FILEPATH', GDRIVE_PATH . FILENAME);
define('DESTINATION', '~/code/appsmiles/ps-android/pharmasimple/src/main/res/values/' . FILENAME);
// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/script-php-quickstart.json
define('SCOPES', implode(' ', array(
  "https://www.googleapis.com/auth/drive",
  "https://www.googleapis.com/auth/spreadsheets")
));

if (php_sapi_name() != 'cli') {
  throw new Exception('This application must be run on the command line.');
}

/**
 * Returns an authorized API client.
 * @return Google_Client the authorized client object
 */
function getClient() {
  $client = new Google_Client();
  $client->setApplicationName(APPLICATION_NAME);
  $client->setScopes(SCOPES);
  $client->setAuthConfig(CLIENT_SECRET_PATH);
  $client->setAccessType('offline');

  // Load previously authorized credentials from a file.
  $credentialsPath = expandHomeDirectory(CREDENTIALS_PATH);
  if (file_exists($credentialsPath)) {
    $accessToken = json_decode(file_get_contents($credentialsPath), true);
  } else {
    // Request authorization from the user.
    $authUrl = $client->createAuthUrl();
    printf("Open the following link in your browser:\n%s\n", $authUrl);
    print 'Enter verification code: ';
    $authCode = trim(fgets(STDIN));

    // Exchange authorization code for an access token.
    $accessToken = $client->fetchAccessTokenWithAuthCode($authCode);

    // Store the credentials to disk.
    if(!file_exists(dirname($credentialsPath))) {
      mkdir(dirname($credentialsPath), 0700, true);
    }
    file_put_contents($credentialsPath, json_encode($accessToken));
    printf("Credentials saved to %s\n", $credentialsPath);
  }
  $client->setAccessToken($accessToken);

  // Refresh the token if it's expired.
  if ($client->isAccessTokenExpired()) {
    $client->fetchAccessTokenWithRefreshToken($client->getRefreshToken());
    file_put_contents($credentialsPath, json_encode($client->getAccessToken()));
  }
  return $client;
}

/**
 * Expands the home directory alias '~' to the full path.
 * @param string $path the path to expand.
 * @return string the expanded path.
 */
function expandHomeDirectory($path) {
  $homeDirectory = getenv('HOME');
  if (empty($homeDirectory)) {
    $homeDirectory = getenv('HOMEDRIVE') . getenv('HOMEPATH');
  }
  return str_replace('~', realpath($homeDirectory), $path);
}

// Get the API client and construct the service object.
$client = getClient();
$service = new Google_Service_Script($client);

$scriptId = '1dHjXWabgMEhlktqdgA0LkqDh4vUfjiFnhpBhEOSFOTLbw3veNMk_UkSx';

// Create an execution request object.
$request = new Google_Service_Script_ExecutionRequest();
$request->setFunction('exportForAndroidToDrive');

try {
  // Make the API request.
  $timestamp = DateTime::getTimeStamp();
  $response = $service->scripts->run($scriptId, $request);

  if ($response->getError()) {
    // The API executed, but the script returned an error.

    // Extract the first (and only) set of error details. The values of this
    // object are the script's 'errorMessage' and 'errorType', and an array of
    // stack trace elements.
    $error = $response->getError()['details'][0];
    printf("Script error message: %s\n", $error['errorMessage']);

    if (array_key_exists('scriptStackTraceElements', $error)) {
      // There may not be a stacktrace if the script didn't start executing.
      print "Script error stacktrace:\n";
      foreach($error['scriptStackTraceElements'] as $trace) {
        printf("\t%s: %d\n", $trace['function'], $trace['lineNumber']);
      }
    }
  } else {
    // The structure of the result will depend upon what the Apps Script
    // function returns. Here, the function returns an Apps Script Object
    // with String keys and values, and so the result is treated as a
    // PHP array (folderSet).
    $resp = $response->getResponse();
    $chrono = 0;
    $outcome = "";
    while(!file_exists(FILEPATH) && filectime(FILEPATH) < $timestamp)
    {
      if($chrono > 60) { $outcome = "timeout"; break; }
      sleep(2);
      $chrono += 2;
      echo "File has not synced with Drive yet."
    }
    if($outcome != "timeout") {
      rename(FILEPATH, DESTINATION);
      echo "SUCCESS: File moved to " . DESTINATION;
    }

  }
} catch (Exception $e) {
  // The API encountered a problem before the script started executing.
  echo 'Caught exception: ', $e->getMessage(), "\n";
}
