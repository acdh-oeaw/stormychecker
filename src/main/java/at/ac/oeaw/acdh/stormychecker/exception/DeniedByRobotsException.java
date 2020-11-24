package at.ac.oeaw.acdh.stormychecker.exception;

/**
 * robots.txt didn't allow for the checking of the link
 */
public class DeniedByRobotsException extends Exception {

    public DeniedByRobotsException(String message){
        super(message);
    }
}
