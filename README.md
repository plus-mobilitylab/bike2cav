# Bike2CAV evaluation

The evaluation of the network-based interaction zones in the scope of the Bike2CAV project. See the [evaluation notebook](https://plus-mobilitylab.github.io/bike2cav/evaluation.html) for a description of the workflow and the results.

## To reproduce

A Docker image is provided such that you can reproduce and interactively explore the notebook inside a containerized environment containing all required dependencies. Given that you have Docker and git installed, you can do so with the following steps:

**1. Clone and access this repository**

Clone this repository with git to your computer, and access the cloned directory, as follows:

```
git clone https://github.com/plus-mobilitylab/bike2cav.git
cd bike2cav
```

**2. Get the input data**

The notebook uses a set of input data that are already pre-processed to some extent. Unfortunately, not all these data are openly available. If you are a member of the PLUS Mobility Lab, you can find the data on our network share in the Bike2CAV project directory, under `./5-Projekt/5-7-Evaluation/data.zip`. Store this ZIP file in the data directory of the cloned repository. If you do not have access to these data, please contact lucas.vandermeer@plus.ac.at.

**3. Build the Docker image**

Build the provided Docker image by executing the following command:

```
docker build -t bike2cav .
```

**4. Run a Docker container**

Run a Docker container based on the provided iamge by executing the following command:

```
docker run --rm --name bike2cav -e DISABLE_AUTH=TRUE -e USERID=$UID -p 8787:8787 -v ${PWD}:/home/rstudio/ bike2cav
```

**5. Open a locally hosted RStudio Server**

By running the Docker container you have started a RStudio Server session running on port 8787. To access this, open a browser and navigate to http://localhost:8787/.

**6. Launch the RStudio project**

In the *Files* tab (bottom-right of the RStudio interface), open a file called `bike2cav.Rproj`.

**7. Open the notebook**

In the *Files* tab (bottom-right of the RStudio interface), open a file called `evaluation.qmd`. This will open a Quarto notebook, containing a combination of Markdown formatted text with R code chuncks. You can run each chunck separately and experiment with changing code and/or certain parameters.

**8. Render the notebook**

To render the full notebook into a HTML document, click *Render* in the menu above the notebook.