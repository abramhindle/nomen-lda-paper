/* package mulan.examples; */

/**
 *
 * @author greg
 */

import mulan.classifier.MultiLabelLearner;
import mulan.classifier.lazy.MLkNN;
import mulan.classifier.meta.HMC;
import mulan.classifier.meta.HOMER;
import mulan.classifier.meta.HierarchyBuilder;
import mulan.classifier.meta.RAkEL;
import mulan.classifier.transformation.BinaryRelevance;
import mulan.classifier.transformation.CalibratedLabelRanking;
import mulan.classifier.transformation.IncludeLabelsClassifier;
import mulan.classifier.transformation.LabelPowerset;
import mulan.classifier.transformation.MultiClassLearner;
import mulan.classifier.transformation.MultiLabelStacking;
import mulan.data.MultiLabelInstances;
import mulan.evaluation.Evaluation;
import mulan.evaluation.MultipleEvaluation;
import mulan.evaluation.Evaluator;
import mulan.transformations.multiclass.Copy;
import mulan.transformations.multiclass.Ignore;
import mulan.transformations.multiclass.MultiClassTransformation;
import weka.classifiers.Classifier;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.functions.SMO;
import weka.classifiers.trees.J48;
import weka.core.Utils;

public class CrossValidationExperiment {

	/**
	 * Creates a new instance of this class
	 */
	public CrossValidationExperiment() {
	}

	public static void main(String[] args) {
		String[] methodsToCompare = { "HOMER", "BR", "CLR", "MLkNN", "MC-Copy",
				//"IncludeLabels", "MC-Ignore", "RAkEL", "LP", "MLStacking" };
				"IncludeLabels", "MC-Ignore", "RAkEL", "LP" };

		try {
			String path = Utils.getOption("path", args);
			String filestem = Utils.getOption("filestem", args);
			System.out.println("Loading the data set");
			MultiLabelInstances dataSet = new MultiLabelInstances(path
					+ filestem + ".arff", path + filestem + ".xml");

			Evaluator eval = new Evaluator();
			MultipleEvaluation results = null;
			boolean debugOn = true;
			int numFolds = 10;

			for (int i = 0; i < methodsToCompare.length; i++) {
				try {
				System.out.println(methodsToCompare[i]);
				if (methodsToCompare[i].equals("BR")) {
					Classifier brClassifier = new NaiveBayes();
					BinaryRelevance br = new BinaryRelevance(brClassifier);
					br.setDebug( debugOn );
					results = eval.crossValidate(br, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("LP")) {
					Classifier lpBaseClassifier = new J48();
					LabelPowerset lp = new LabelPowerset(lpBaseClassifier);
					lp.setDebug( debugOn );
					results = eval.crossValidate(lp, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("CLR")) {
					Classifier clrClassifier = new J48();
					CalibratedLabelRanking clr = new CalibratedLabelRanking(
							clrClassifier);
					clr.setDebug( debugOn );
					results = eval.crossValidate(clr, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("RAkEL")) {
					MultiLabelLearner lp = new LabelPowerset(new J48());
					RAkEL rakel = new RAkEL(lp);
					rakel.setDebug( debugOn );
					results = eval.crossValidate(rakel, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("MC-Copy")) {
					Classifier mclClassifier = new J48();
					MultiClassTransformation mcTrans = new Copy();
					MultiClassLearner mcl = new MultiClassLearner(
							mclClassifier, mcTrans);
					mcl.setDebug( debugOn );
					results = eval.crossValidate(mcl, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("MC-Ignore")) {
					Classifier mclClassifier = new J48();
					MultiClassTransformation mcTrans = new Ignore();
					MultiClassLearner mcl = new MultiClassLearner(
							mclClassifier, mcTrans);
					results = eval.crossValidate(mcl, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("IncludeLabels")) {
					Classifier ilClassifier = new J48();
					IncludeLabelsClassifier il = new IncludeLabelsClassifier(
							ilClassifier);
					il.setDebug( debugOn );
					results = eval.crossValidate(il, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("MLkNN")) {
					int numOfNeighbors = 10;
					double smooth = 1.0;
					MLkNN mlknn = new MLkNN(numOfNeighbors, smooth);
					mlknn.setDebug( debugOn );
					results = eval.crossValidate(mlknn, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("HMC")) {
					Classifier baseClassifier = new J48();
					LabelPowerset lp = new LabelPowerset(baseClassifier);
					RAkEL rakel = new RAkEL(lp);
					HMC hmc = new HMC(rakel);
					results = eval.crossValidate(hmc, dataSet, numFolds);
				}

				if (methodsToCompare[i].equals("HOMER")) {
					Classifier baseClassifier = new SMO();
					CalibratedLabelRanking learner = new CalibratedLabelRanking(
							baseClassifier);
					learner.setDebug( debugOn );
					HOMER homer = new HOMER(learner, 3, HierarchyBuilder.Method.Random);
					homer.setDebug( debugOn );
					results = eval.crossValidate(homer, dataSet, numFolds);
					
				}
				//if (methodsToCompare[i].equals("MLStacking")) {
				//	J48 baseClassifier = new J48();
				//	J48 metaClassifier = new J48();
				//	baseClassifier.setUseLaplace(true);
				//	metaClassifier.setUseLaplace(true);
				//	MultiLabelStacking mls = new MultiLabelStacking(
				//			baseClassifier, metaClassifier, 10);
				//	mls.setDebug( debugOn );
				//	mls.setPhival(0.06);
				//	results = eval.crossValidate(mls, dataSet, numFolds);
				//}
				System.out.println(results.toString());
				System.out.println(results.toCSV());
				} catch (java.io.NotSerializableException e) {
					e.printStackTrace();
				} catch (java.lang.ArrayIndexOutOfBoundsException e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
