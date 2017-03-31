
/*
 *    DriftDetectionMethodClassifier.java
 *    Copyright (C) 2008 University of Waikato, Hamilton, New Zealand
 *    @author Manuel Baena (mbaena@lcc.uma.es)
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package moa.classifiers.drift;

        import com.yahoo.labs.samoa.instances.Instance;
        import java.util.LinkedList;
        import java.util.List;
        import java.util.ArrayList;
        import moa.classifiers.AbstractClassifier;
        import moa.classifiers.Classifier;
        import moa.classifiers.bayes.NaiveBayes;
        import moa.classifiers.meta.WEKAClassifier;
        import moa.core.Measurement;
        import moa.core.Utils;
        import moa.classifiers.core.driftdetection.ChangeDetector;
        import moa.options.ClassOption;

/**
 * Created by Andrzej on 05/02/2017.
 *
 * Check for changes in each feature in a given time window
 * if the distribution has changed significantly (use STEPD approch)
 * then it is indicative of concept drift.
 *
 */
public class LocalDriftDetectionMethodClassifier extends AbstractClassifier{

    private static final long serialVersionUID = 1L;

    @Override
    public String getPurposeString() {
        return "Classifier that replaces the current classifier with a new one when a change is detected in accuracy.";
    }

    public ClassOption baseLearnerOption = new ClassOption("baseLearner", 'l',
            "Classifier to train.", Classifier.class, "bayes.NaiveBayes");


    public ClassOption localLearnerOption = new ClassOption("localLearner", 'k',
            "Classifier to train.", Classifier.class, "bayes.NaiveBayes");

    public ClassOption localDriftDetectionMethodOption = new ClassOption("localDriftDetectionMethod", 'd',
            "Drift detection method to use.", ChangeDetector.class, "DDM");


    protected Classifier classifier;

    protected Classifier newclassifier;

    protected ArrayList<NaiveBayes> localClassifiers;

    protected ChangeDetector driftDetectionMethod;

    protected ArrayList<ChangeDetector> localDetectors;

    protected boolean newClassifierReset;
    //protected int numberInstances = 0;

    protected int ddmLevel;

   /* public boolean isWarningDetected() {
        return (this.ddmLevel == DriftDetectionMethod.DDM_WARNING_LEVEL);
    }

    public boolean isChangeDetected() {
        return (this.ddmLevel == DriftDetectionMethod.DDM_OUTCONTROL_LEVEL);
    }*/

    public static final int DDM_INCONTROL_LEVEL = 0;

    public static final int DDM_WARNING_LEVEL = 1;

    public static final int DDM_OUTCONTROL_LEVEL = 2;

    @Override
    public void resetLearningImpl() {
        this.classifier = ((Classifier) getPreparedClassOption(this.baseLearnerOption)).copy();
        this.newclassifier = this.classifier.copy();
        this.classifier.resetLearning();
        this.newclassifier.resetLearning();
        this.newClassifierReset = false;

        this.localClassifiers = new ArrayList<NaiveBayes>();
        this.localDetectors = new ArrayList<ChangeDetector>();
    }

    protected int changeDetected = 0;

    protected int warningDetected = 0;




    @Override
    public void trainOnInstanceImpl(Instance inst) {
        //this.numberInstances++;
        int trueClass = (int) inst.classValue();
        boolean detCnt = false;
        boolean wzCnt = false;
        boolean prediction;

        if(this.localClassifiers.size() == 0){
            for (int i = 0; i < inst.numAttributes() - 1; i++) {
                Classifier clf = ((Classifier) getPreparedClassOption(this.localLearnerOption)).copy();
                this.localClassifiers.add((NaiveBayes)clf);
            }
        }

        if(this.localDetectors.size() == 0){
            for (int i = 0; i < inst.numAttributes() - 1; i++) {
                ChangeDetector cd = ((ChangeDetector) getPreparedClassOption(this.localDriftDetectionMethodOption)).copy();
                this.localDetectors.add(cd);
            }
        }


        for (int i = 0; i < inst.numAttributes() - 1; i++) {
            if (Utils.maxIndex(this.localClassifiers.get(i).localGetVotesForInstance(inst, i)) == trueClass) {
                prediction = true;
            } else {
                prediction = false;
            }

            this.localDetectors.get(i).input(prediction ? 0.0 : 1.0);
            if(this.localDetectors.get(i).getChange())
            {
                detCnt = true;
            }
            if(this.localDetectors.get(i).getWarningZone())
            {
                wzCnt = true;
            }
            this.localClassifiers.get(i).localLearningMethod(inst, i);
        }


        if (Utils.maxIndex(this.classifier.getVotesForInstance(inst)) == trueClass) {
            prediction = true;
        } else {
            prediction = false;
        }

        //this.ddmLevel = this.driftDetectionMethod.computeNextVal(prediction);
        this.ddmLevel = DDM_INCONTROL_LEVEL;
        if (detCnt) {
            this.ddmLevel =  DDM_OUTCONTROL_LEVEL;
        }
        if (wzCnt) {
            this.ddmLevel =  DDM_WARNING_LEVEL;
        }
        switch (this.ddmLevel) {
            case DDM_WARNING_LEVEL:
                //System.out.println("1 0 W");
                //System.out.println("DDM_WARNING_LEVEL");
                if (newClassifierReset == true) {
                    this.warningDetected++;
                    this.newclassifier.resetLearning();
                    newClassifierReset = false;
                }
                this.newclassifier.trainOnInstance(inst);
                break;

            case DDM_OUTCONTROL_LEVEL:
                //System.out.println("0 1 O");
                //System.out.println("DDM_OUTCONTROL_LEVEL");
                this.changeDetected++;
                this.classifier = null;
                this.classifier = this.newclassifier;
                if (this.classifier instanceof WEKAClassifier) {
                    ((WEKAClassifier) this.classifier).buildClassifier();
                }
                this.newclassifier = ((Classifier) getPreparedClassOption(this.baseLearnerOption)).copy();
                this.newclassifier.resetLearning();
                break;

            case DDM_INCONTROL_LEVEL:
                //System.out.println("0 0 I");
                //System.out.println("DDM_INCONTROL_LEVEL");
                newClassifierReset = true;
                break;
            default:
                //System.out.println("ERROR!");

        }

        this.classifier.trainOnInstance(inst);
    }

    public double[] getVotesForInstance(Instance inst) {
        return this.classifier.getVotesForInstance(inst);
    }

    @Override
    public boolean isRandomizable() {
        return true;
    }

    @Override
    public void getModelDescription(StringBuilder out, int indent) {
        ((AbstractClassifier) this.classifier).getModelDescription(out, indent);
    }

    @Override
    protected Measurement[] getModelMeasurementsImpl() {
        List<Measurement> measurementList = new LinkedList<Measurement>();
        measurementList.add(new Measurement("Change detected", this.changeDetected));
        measurementList.add(new Measurement("Warning detected", this.warningDetected));
        Measurement[] modelMeasurements = ((AbstractClassifier) this.classifier).getModelMeasurements();
        if (modelMeasurements != null) {
            for (Measurement measurement : modelMeasurements) {
                measurementList.add(measurement);
            }
        }
        this.changeDetected = 0;
        this.warningDetected = 0;
        return measurementList.toArray(new Measurement[measurementList.size()]);
    }

}
