{-# LANGUAGE ScopedTypeVariables #-}
import Prelude hiding (filter)
import System.Environment (getArgs)

import Vision.Image
import Vision.Image.Storage.DevIL (Autodetect (..), load, save)

-- Applies a Gaussian blur to an image.
--
-- usage: ./gaussian_blur input.png output.png
main :: IO ()
main = do
    [input, output] <- getArgs

    -- Loads the image. Automatically infers the format.
    io <- load Autodetect input

    case io of
        Left err             -> do
            putStrLn "Unable to load the image:"
            print err
        Right (grey :: Grey) -> do
            let -- Applies a Gaussian filter with a 5x5 Double kernel to remove
                -- small noises.
                blurred :: Grey
                blurred = gaussianBlur 2 (Nothing :: Maybe Double) grey

            -- Saves the blurred image. Automatically infers the output format.
            mErr <- save Autodetect output blurred
            case mErr of
                Nothing  ->
                    putStrLn "Success."
                Just err -> do
                    putStrLn "Unable to save the image:"
                    print err
